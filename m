Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAB36175C
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 21:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfGGTu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 15:50:59 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39605 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727052AbfGGTu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 15:50:58 -0400
Received: by mail-wm1-f67.google.com with SMTP id z23so14284145wma.4
        for <netdev@vger.kernel.org>; Sun, 07 Jul 2019 12:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0UfEokpDO7/BgLoysqOsAu7RN9VuohDGtbmCLQElg6I=;
        b=rwD7zi9xuNSpkrv1MGRxm/NqjOHVEG7tQySqLvAb7JYJlLtl0tAlX5exwbLKC0nyvs
         HQGoCNhV80dIjRuG4W+9WcTbuEN9/qsqjEUSNqy0WuknbF+rTT0KyQ9aBdURBcDXAtDE
         XnwSgNurwYZAZKPgGGfh18njoM2uDi8sdStyzmiPixy+NJgOs6vQg4psTLgHXjZEkaSO
         fYN4vRzHp1of7IcYk/Y3scEVV1oPk7oekNIqrZe4/lZM5Cy0NC4pRsVMnK1pO6qTcGxG
         eW+eE8vCy7WrZ4EcKi05FqZ3thWniqHhXPitejzHdd/22Hx75EGr/64weD1DBuds2Y5Y
         Z0Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0UfEokpDO7/BgLoysqOsAu7RN9VuohDGtbmCLQElg6I=;
        b=e17D6Qz/JuhsPqC1G8ZyTaer+IzYA9nabjaRgY+zq8jH4ezhZcLK5hWAw7hC7yt35I
         l4WciZvC+eBre54DyksiUpqhv8l23AAr4TRjcYgoOXTj9JZXlM1ctGS4NZzO1xJSD4AP
         I1Ale1nktn5DWYTAOOTnaNC4iE4qs7NQdFWxtobgGfH2yy6NhB/1VimunviwOSWecefO
         Ew0P9mZ3OKfEmWoQwjK2hbZozDT+AT/AHVWM7N4BagLMuC+NewbnTwi7kOzRj4s2AD8b
         ahPBcErUdlcunYOVjjyVEb34E3BO8wSTALCdaSE+SADkrLAzDT6yN5kUtxFi+7pmUPo8
         rHtw==
X-Gm-Message-State: APjAAAWWUThzhZLDBKTw1bK8xxXYB5HOaOayRLqPcR0wNANltor1dYUm
        8UuhhPbDNKvCm3nowKnCHWQlKA==
X-Google-Smtp-Source: APXvYqyFv/9xu15rWKDb2wuJm0tY3X+tVFjquOcCEBSuDmxyxhRQYwNtxzq6uOFrPKLDDj3KTpQeSQ==
X-Received: by 2002:a05:600c:2182:: with SMTP id e2mr12898268wme.104.1562529056683;
        Sun, 07 Jul 2019 12:50:56 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id m16sm13693762wrv.89.2019.07.07.12.50.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 07 Jul 2019 12:50:56 -0700 (PDT)
Date:   Sun, 7 Jul 2019 21:50:55 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Parav Pandit <parav@mellanox.com>
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, saeedm@mellanox.com,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next v4 3/4] devlink: Introduce PCI VF port flavour
 and port attribute
Message-ID: <20190707195055.GC2306@nanopsycho.orion>
References: <20190701122734.18770-1-parav@mellanox.com>
 <20190706182350.11929-1-parav@mellanox.com>
 <20190706182350.11929-4-parav@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190706182350.11929-4-parav@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Jul 06, 2019 at 08:23:49PM CEST, parav@mellanox.com wrote:
>In an eswitch, PCI VF may have port which is normally represented using
>a representor netdevice.
>To have better visibility of eswitch port, its association with VF,
>and its representor netdevice, introduce a PCI VF port flavour.
>
>When devlink port flavour is PCI VF, fill up PCI VF attributes of
>the port.
>
>Extend port name creation using PCI PF and VF number scheme on best
>effort basis, so that vendor drivers can skip defining their own scheme.
>
>$ devlink port show
>pci/0000:05:00.0/0: type eth netdev eth0 flavour pcipf pfnum 0
>pci/0000:05:00.0/1: type eth netdev eth1 flavour pcivf pfnum 0 vfnum 0
>pci/0000:05:00.0/2: type eth netdev eth2 flavour pcivf pfnum 0 vfnum 1
>
>Signed-off-by: Parav Pandit <parav@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
