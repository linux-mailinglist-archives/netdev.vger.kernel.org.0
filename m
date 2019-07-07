Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03B596175D
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 21:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfGGTvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 15:51:49 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41190 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727052AbfGGTvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 15:51:48 -0400
Received: by mail-wr1-f67.google.com with SMTP id c2so14745295wrm.8
        for <netdev@vger.kernel.org>; Sun, 07 Jul 2019 12:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tDXg4QGV2IMT48OTrBETt1TbUUuDKHM5zT228042dDQ=;
        b=rwaWHTfabfyRkA9cXnKicSVuGQzsSzkocSU9pWxiCgyOtTrzBm00EcyrLUsrNYBPNh
         nA7gGR16G/bpRaBeB4uJLYCxoEmU+vI840qLxb21VuL72qe+xL2hsR4z7mTixUYAYujM
         3/XCgCziDype/r49JymyF3WKlP41ICG1xEkq9m2xpnLtUFfDTRwcGQe7wsbr4POo1URV
         g1IRDw7XdwqIDOD6R21p2p/adPlaIOKFgV79iPTrTCC5RJZLqqhlYBiEgonwg8J33UKy
         Abh073xNtqhzpdTjzKI3QYrBxCreLSX4vI5jyk4LNE4M42ygRpw+ZRS2xUt9K8uCFO9F
         Gw4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tDXg4QGV2IMT48OTrBETt1TbUUuDKHM5zT228042dDQ=;
        b=MTEkTkspW6PJAPsx02DUp/I5aD/j9lKXGfyYpkTSSVD/K0z1AG4u9qQ+QWMF00SxXX
         sCAXlKsm0GtrSzPctB3qGutTKCredPmWR1fD7pUh/PyoVv0lxMxlT9Qu/88ZBQMG4OQG
         chsB0+k6MlvE8ca0xskXhvFQULxDQwE3cU2m59c75oQ0RKMOZ0zcECV8tPYb6LEpL9X1
         WScqtMpYekys2keXTbLLkaGAV6UQPUiCR25yjSE7z7OykefoOW7bHH3uBlFIsH34qkRx
         jztMF1cg2hDQK0OoVe7VJBdWmJ/xVGLMRiGLH09ubiOnAa9BDPEBDe8qGQIwr9h9NkiS
         Qjiw==
X-Gm-Message-State: APjAAAW/YxTc9tr2xMSPQIDaziomqHvMYUR/VL4A9JnX7dXYfjfy27NI
        epqpeyYpmNeM3LytHmpGcX7Q39IpVrM=
X-Google-Smtp-Source: APXvYqwQGjTwXaVt0m4CbkPtpZaZnrouVRimADphrIofg/kfkBtCyrgPVsvghghtf2HE+1reFWeMIQ==
X-Received: by 2002:adf:e9c6:: with SMTP id l6mr15106144wrn.216.1562529106951;
        Sun, 07 Jul 2019 12:51:46 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id v124sm15826726wmf.23.2019.07.07.12.51.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 07 Jul 2019 12:51:46 -0700 (PDT)
Date:   Sun, 7 Jul 2019 21:51:46 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Parav Pandit <parav@mellanox.com>
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, saeedm@mellanox.com,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next v4 4/4] net/mlx5e: Register devlink ports for
 physical link, PCI PF, VFs
Message-ID: <20190707195146.GD2306@nanopsycho.orion>
References: <20190701122734.18770-1-parav@mellanox.com>
 <20190706182350.11929-1-parav@mellanox.com>
 <20190706182350.11929-5-parav@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190706182350.11929-5-parav@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Jul 06, 2019 at 08:23:50PM CEST, parav@mellanox.com wrote:
>Register devlink port of physical port, PCI PF and PCI VF flavour
>for each PF, VF when a given devlink instance is in switchdev mode.
>
>Implement ndo_get_devlink_port callback API to make use of registered
>devlink ports.
>This eliminates ndo_get_phys_port_name() and ndo_get_port_parent_id()
>callbacks. Hence, remove them.
>
>An example output with 2 VFs, without a PF and single uplink port is
>below.
>
>$devlink port show
>pci/0000:06:00.0/65535: type eth netdev ens2f0 flavour physical
>pci/0000:05:00.0/1: type eth netdev eth1 flavour pcivf pfnum 0 vfnum 0
>pci/0000:05:00.0/2: type eth netdev eth2 flavour pcivf pfnum 0 vfnum 1
>
>Reviewed-by: Roi Dayan <roid@mellanox.com>
>Signed-off-by: Parav Pandit <parav@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
