Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3779B139EF
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 15:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfEDNAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 09:00:31 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34016 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbfEDNAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 09:00:31 -0400
Received: by mail-wm1-f67.google.com with SMTP id m20so1817035wmg.1
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 06:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LPWEcRItiB/7n0LrdqG6D2jT08M/+uIF1SnQrm3fAo8=;
        b=HU+9/cKRWuldjXWoP9Prxxp0opQNQgKn9HRoCa1zEIyCmGMmW2DDSco91ExklzkiuH
         zJ9eY6mTxguqAvH8Jd9VBlvmMDFHu6Aa8b+2+gGDMQgUvlRAMNVgHREX0jjtq+GDh5NJ
         DLTXDv/Hj9wyL1ksckPe2JHza8x1qxyhKWWqYXXZ0v/lMOLyNL3OwYdgEaEkV0VC8OYQ
         JCnv3t+jDLmFq0/thvj6FM0XrQrcUxjsQCOtZHzldGqVDlIweSSsxPZmF03JHtEEcZ1A
         8ukeiy/2ZRSraWwNmUNiV/GOfViPySiF+ZKYhAmEiEW5gXADdnY0ocLgqYV6NF45iI7x
         Cdyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LPWEcRItiB/7n0LrdqG6D2jT08M/+uIF1SnQrm3fAo8=;
        b=cIAYUw4csTVVuGTrxnQAzMLnDsFf9xBmJVjBKX55MWysW2AB853RYoDl0KvBSapgMb
         jmJ5eFW7+U282zHFfCqfPKQNhIiZmsktlZ2EnvFHYwKa9qvTMVVUBlfsHDvU+EgeR+FT
         01iOYbA39oNWm4dMv71wIAfSQkIQtEuZP7CYfPCgBaxwdi5LmFfKARH8dbEaOEm4JWqj
         Aya52WphxbFqlNFQ6/ZFxylptE43lHNpTD/eoubTU0StTtxC5/DRza0KA0Jil03k0ppp
         dx8mIPFlm/Fj7IzWV1KA7qD1w0tQiBC0/M1/WB8nBhJDZkCi82pMAKXBHKKRik5lCWgK
         8k3A==
X-Gm-Message-State: APjAAAXlNo+t1gs8Mj0dpcHoY8TtPfyMJKjtC6PR3bBZ9JUAnhuM2PPN
        twO6wOuq1Kyit7JO31Zvrbdl1g==
X-Google-Smtp-Source: APXvYqwIw5McBk/SlHbh4tOJna2UcGCMsZIH7eo8nSORv1v6WkLa2i9hKnPrS261+9dCg2qWL50Dmg==
X-Received: by 2002:a1c:f205:: with SMTP id s5mr10187424wmc.124.1556974829640;
        Sat, 04 May 2019 06:00:29 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id n2sm7774133wra.89.2019.05.04.06.00.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 04 May 2019 06:00:29 -0700 (PDT)
Date:   Sat, 4 May 2019 15:00:28 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@netronome.com, xiyou.wangcong@gmail.com,
        idosch@mellanox.com, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, gerlitz.or@gmail.com,
        simon.horman@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>
Subject: Re: [PATCH net-next 04/13] net/dsa: use intermediate representation
 for matchall offload
Message-ID: <20190504130028.GE9049@nanopsycho.orion>
References: <20190504114628.14755-1-jakub.kicinski@netronome.com>
 <20190504114628.14755-5-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190504114628.14755-5-jakub.kicinski@netronome.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, May 04, 2019 at 01:46:19PM CEST, jakub.kicinski@netronome.com wrote:
>From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
>
>Updates dsa hardware switch handling infrastructure to use the newer
>intermediate representation for flow actions in matchall offloads.
>
>Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
>Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
