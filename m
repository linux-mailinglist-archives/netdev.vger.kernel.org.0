Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFEF1154B1
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 21:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfEFTyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 15:54:20 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46220 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbfEFTyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 15:54:20 -0400
Received: by mail-pl1-f194.google.com with SMTP id bi2so6874460plb.13
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 12:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Rm9SMfvnydhLhcx4SA7q/iYhVHUPFyZzONl50gsHFTo=;
        b=W6psGKWkSl4rmx2PL8Qqr4z4pLx2r+FT/VxizmHQZJQemQ8kxyCwSZQlA4t0t3a6NQ
         +UgwOMqBTci4CZ5oSb8GEB5DwIKl5a8z2sdILk+jXhBInjAJ3jwbRdsCvOi/cXMT8YNR
         QD5XF865DulcGQTyFDJKHdDKgmCCueBULlcyKNhGuTC5um1vw5lLn9PoO931XGP4TEpr
         E3ZH6LO4pw2KjmVszUJ+aMkWn4U/gDRFeBpWwC5Kua5QqXdoPevJqLn4n50co9OxZY9z
         KPVYhoskm4JpzCJjhjY6Lq7X02fNkYNLP7nimFtB6f4LlK/L/rZAoTPX20yTnyZhV5zy
         A/Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Rm9SMfvnydhLhcx4SA7q/iYhVHUPFyZzONl50gsHFTo=;
        b=FNe4el4KmiBhmzRKRZwI2atKVQneVpKLXiyUO9Bkhe5dVWU1QJQ60FBba38hsvJfPW
         axoczp7hIrZmBIMM7M7J8fcr5RMAxVKF7zmyweCYfnJqPuxmpdsATECsjZMYj/oTuej0
         1OXiZHixpNIl70AVSwgF+9WdLC2oHi88562uLMhs4QBqymSDiIhyqNXsJPC2KLSoL0SG
         F/LwZxnP055mCjbz1lrh7+dW+YsyN51k/yyUyHT/h1o4OogERqaQoHeKUB4eLiqfIQzb
         mZsSmKdheEX5eayZ0NlNN0RVUc+yheSViIDzDiIrCLrFcpIUeYrxAUhJGWDetYVh6osI
         z8vw==
X-Gm-Message-State: APjAAAV/zqHlY/hKdQzM/qdlZHHZimCjKQI53KV4ekzrPSvudAtWfcNH
        XoJAkLhfQClM9M95sZmJ/GqRIm7/
X-Google-Smtp-Source: APXvYqxflhB119agpOB4TpZZ/bujdhPOd5G3pdFzKSHkgHl+uVFq5aQHaPzVfkD8x6IyAqkwUyY+XQ==
X-Received: by 2002:a17:902:8306:: with SMTP id bd6mr34746503plb.134.1557172458921;
        Mon, 06 May 2019 12:54:18 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:80c3:e1ec:92e3:5225? ([2601:282:800:fd80:80c3:e1ec:92e3:5225])
        by smtp.googlemail.com with ESMTPSA id p2sm7332453pgd.63.2019.05.06.12.54.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 12:54:18 -0700 (PDT)
Subject: Re: [PATCH net] vrf: sit mtu should not be updated when vrf netdev is
 the link
To:     Stephen Suryaputra <ssuryaextr@gmail.com>, netdev@vger.kernel.org
References: <20190506190001.6567-1-ssuryaextr@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <667fd9b5-6122-bd9f-e6ae-e08d82197ef9@gmail.com>
Date:   Mon, 6 May 2019 13:54:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190506190001.6567-1-ssuryaextr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/6/19 1:00 PM, Stephen Suryaputra wrote:
> VRF netdev mtu isn't typically set and have an mtu of 65536. When the
> link of a tunnel is set, the tunnel mtu is changed from 1480 to the link
> mtu minus tunnel header. In the case of VRF netdev is the link, then the
> tunnel mtu becomes 65516. So, fix it by not setting the tunnel mtu in
> this case.
> 
> Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
> ---
>  net/ipv6/sit.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
> index b2109b74857d..971d60bf9640 100644
> --- a/net/ipv6/sit.c
> +++ b/net/ipv6/sit.c
> @@ -1084,7 +1084,7 @@ static void ipip6_tunnel_bind_dev(struct net_device *dev)
>  	if (!tdev && tunnel->parms.link)
>  		tdev = __dev_get_by_index(tunnel->net, tunnel->parms.link);
>  
> -	if (tdev) {
> +	if (tdev && !netif_is_l3_master(tdev)) {
>  		int t_hlen = tunnel->hlen + sizeof(struct iphdr);
>  
>  		dev->hard_header_len = tdev->hard_header_len + sizeof(struct iphdr);
> 

can you explain how tdev is a VRF device? What's the config setup for
this case?
