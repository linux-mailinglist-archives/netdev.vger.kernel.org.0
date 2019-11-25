Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD0D1096D8
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 00:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfKYXQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 18:16:26 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:38913 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfKYXQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 18:16:26 -0500
Received: by mail-qk1-f196.google.com with SMTP id z65so9686021qka.6
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 15:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oHCBD3LvA5ZjlC1lOqQdqhA9HhBe4m3pwKrHjcO7Ba8=;
        b=YmUONKM57bDrism6VeQrc5vmv3rH+9B3l5pFElJF7v/WudtM7vYEIONZIv63gACOnd
         N+w7WDyPHgwL9pynkc3er9AYftBmM9WaU7HEQADh+3lT/wkBNnDDexMtR0cQZxchgGse
         jOuiQ6mYQDt1szcybS5H4SqKV6GBsoQ1JXv0Qu18mUnspwHTJyUfopPD/CG7zYj4xg97
         uoPTULXJvPD0wf4gSCj3PpAsypRgODKAzP9QPKWyvBS/nssAerFclFR2Ys2jW/UE5nCl
         S+WUR07e/edseyJw43nCKl9oeZ9ZSiD0sgud03TwqMMhqGhHiowzBBar6Ob1fkqFgIM+
         z7bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oHCBD3LvA5ZjlC1lOqQdqhA9HhBe4m3pwKrHjcO7Ba8=;
        b=tC9oax5cAe7Rrxro3CGqTSY8F4rxOPqg9Jod8VZhB3pjZWOMNHIwsjZ2nIjdMBGb25
         DEqC0Xjx5KSkUe1cLnygGeF3tpIxlmg/DKEZix5voCmyhGBydo19Z/FFb0X/GMas62R4
         iv/3YLXhivCbjb8iDG6WFXlkPWdVZbhSR+kEPOhJuMJ/W5fqlKhka8mubcxaNnrertdp
         r6HASQFFW9CD+ekOW7cRWKE63EGUE5n9Ti3PBzx3GTKYD3yuPiX0rzLTdkrXhx0X5yHd
         tPYPO6nwkZS8YJNnoLczWcvgTNsSKNmz3CuoyfmJSLM3M/sbftLgTfps7eI1dpxLvch5
         LTiw==
X-Gm-Message-State: APjAAAWm6p/7wH3X8DjuqKoiWVububJciOBZgCViw0MyGnIqT1xdMM5E
        tkN9pSlnp5wc0rQ06HKLKD5H9eXg
X-Google-Smtp-Source: APXvYqw77GIhC/wI0KKdYtNbHjNOAjrXjiFW3c8AHnwbk7r3fFNUPz2UBIebdmS+ZgGrXM1fq1WVZw==
X-Received: by 2002:a37:4852:: with SMTP id v79mr29463308qka.293.1574723785546;
        Mon, 25 Nov 2019 15:16:25 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:c06f:8df5:46f1:d3e5])
        by smtp.googlemail.com with ESMTPSA id n66sm4140652qkb.72.2019.11.25.15.16.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2019 15:16:24 -0800 (PST)
Subject: Re: [iproute2-next] tipc: add new commands to set TIPC AEAD key
To:     Tuong Lien <tuong.t.lien@dektech.com.au>, jon.maloy@ericsson.com,
        maloy@donjonn.com, ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
References: <20191121034646.16737-1-tuong.t.lien@dektech.com.au>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f10b8f69-e9d8-e69d-3c28-f73f37007cd5@gmail.com>
Date:   Mon, 25 Nov 2019 16:16:23 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191121034646.16737-1-tuong.t.lien@dektech.com.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/20/19 8:46 PM, Tuong Lien wrote:
> Two new commands are added as part of 'tipc node' command:
> 
>  $tipc node set key KEY [algname ALGNAME] [nodeid NODEID]
>  $tipc node flush key
> 
> which enable user to set and remove AEAD keys in kernel TIPC (requires
> the kernel option - 'TIPC_CRYPTO').
> 
> For the 'set key' command, the given 'nodeid' parameter decides the
> mode to be applied to the key, particularly:
> 
> - If NODEID is empty, the key is a 'cluster' key which will be used for
> all message encryption/decryption from/to the node (i.e. both TX & RX).
> The same key will be set in the other nodes.
> 
> - If NODEID is own node, the key is used for message encryption (TX)
> from the node. Whereas, if NODEID is a peer node, the key is for
> message decryption (RX) from that peer node. This is the 'per-node-key'
> mode that each nodes in the cluster has its specific (TX) key.
> 
> Acked-by: Ying Xue <ying.xue@windriver.com>
> Acked-by: Jon Maloy <jon.maloy@ericsson.com>
> Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
> ---
>  include/uapi/linux/tipc.h         |  21 ++++++
>  include/uapi/linux/tipc_netlink.h |   4 ++
>  tipc/misc.c                       |  38 +++++++++++
>  tipc/misc.h                       |   1 +
>  tipc/node.c                       | 133 +++++++++++++++++++++++++++++++++++++-
>  5 files changed, 195 insertions(+), 2 deletions(-)
> 

applied to iproute2-next. Thanks


