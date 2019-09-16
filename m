Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42D3DB3614
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 10:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730786AbfIPIBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 04:01:01 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39942 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbfIPIBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 04:01:01 -0400
Received: by mail-wr1-f65.google.com with SMTP id l3so15040547wru.7
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 01:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/AXLuIRIEGPsxuGlfn5VhZuUQ7zJhCDOgRYeFm54iQE=;
        b=kL57Dcid1UQv5psKgzYo9EuinVXjAmHqV8d5IcNRcCykPCxDAz0hpoh7etBowFNKZu
         0JC7MWNTs+sQoj8OS1TwXaEIWaqMVITjuHV8cs103PKrHdcPnHT1hNQ0IIrSk5qhE38y
         B46Kej+qez7X3h3Ektp7wtcBtDu7VyDsn3kFV3dfW8ZirpN2viaSj8hRT7Hql8M3dzjj
         wrb+vjJRrSjgtG05QIDX9h+VmlEiJS2Dws47JlpNEFhhXLxOiZ9jS4nzEVvwiy7KpGcS
         ZppY+qdef+K2ka/2/iYMdZBlksfdGMbJMVZrQq/c2eAutISSbLQeVHOOZdxTZD2F+zCn
         4fvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/AXLuIRIEGPsxuGlfn5VhZuUQ7zJhCDOgRYeFm54iQE=;
        b=K9easBXGzy/ak2OGPAP/Mp8uT4SBzdvKEoXMQB1jY/PnndtxIcxBzrqSjnVgcNwNTp
         YR0PDdNJurKeKxN5LyHQdSaDJrBV2aeqkiPUABEXQcWXSkTbS+/cFpPr/Vhw7Mws1WhI
         DVHdN4ObUK3I8gjf3lEimyoLMtOJeQB9h65JM9sM3ce73jn0iDAiVnWEiL9EHQtd/fc0
         hgtq2npbUbVYnMr/gA2PHed1lpjUVKzwtCEBv9nB9UXTIaFd8Rz8dpB9XHnpYRQV/CkD
         cEluxXbRXX1r5yc6KDsZSN78xGlQzNX1zvmETrTD9uishd0YHSlmyDL6kisCOKT50XnN
         ETGA==
X-Gm-Message-State: APjAAAV1d9A2TbCemgd3ghOZrAmk6I7VO4cKIUxbpxBKx5OgppZ5GWbl
        iBwFQIjHXZe4/eSAo5tK8LJOZg==
X-Google-Smtp-Source: APXvYqzOFnK5BH48yf4C1qQMmbc/ryMH5BkQqI/NSTlbAm/kV+cMC5Ika2bfRL4MGYNoAppXMOIXUQ==
X-Received: by 2002:a5d:434f:: with SMTP id u15mr49418851wrr.16.1568620859169;
        Mon, 16 Sep 2019 01:00:59 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id a10sm10492415wrm.52.2019.09.16.01.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 01:00:58 -0700 (PDT)
Date:   Mon, 16 Sep 2019 10:00:57 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        shalomt@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v2 3/3] mlxsw: spectrum_buffers: Add the ability
 to query the CPU port's shared buffer
Message-ID: <20190916080057.GL2286@nanopsycho.orion>
References: <20190916061750.26207-1-idosch@idosch.org>
 <20190916061750.26207-4-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916061750.26207-4-idosch@idosch.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Sep 16, 2019 at 08:17:50AM CEST, idosch@idosch.org wrote:
>From: Shalom Toledo <shalomt@mellanox.com>
>
>While debugging packet loss towards the CPU, it is useful to be able to
>query the CPU port's shared buffer quotas and occupancy.
>
>Since the CPU port has no ingress buffers, all the shared buffers ingress
>information will be cleared.
>
>Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
