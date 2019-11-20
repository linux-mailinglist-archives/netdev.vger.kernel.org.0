Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7D7103097
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 01:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfKTAM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 19:12:58 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41213 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727262AbfKTAM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 19:12:58 -0500
Received: by mail-lj1-f193.google.com with SMTP id m4so20484126ljj.8
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 16:12:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=itw5eR7cwMUhlcxQjdV1khV3Xs6+i+HEyoR89Rm7OBI=;
        b=YwtjgNpnHtSceOi2bA+YL7pylgmjYuF1hI02gl8jScq8Uqm4bPAsov+FfLzul4tr0Z
         S4GdwgC1u7QXjNFNEfphQVVNGjMBt//JcMiSZlfNAojI4Rd6WFQvdF5uG0hqF7vZhmwB
         Wl/URNX598LYN33+iMC72YWiCS3nUZysea1v6bzqQ4NOEsgMSu9yfPZrvUTvGnzZuFni
         2ibjk1MlPKgQjbj/RAwKbnHgtxacwgXcVjUHaeLoJHADiFrsYWj5WDVItedc+qOy73dK
         87/A0vidFg7hvNAAeYc02kNtXJ0njUnTjKoJ7tgk8chppj7HFA/7LNJSHdPy5CsffoOE
         maqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=itw5eR7cwMUhlcxQjdV1khV3Xs6+i+HEyoR89Rm7OBI=;
        b=JY85vZ1dPrT3EZKmiWTRawut5/9WeHXAjXgBdp2z6oGMhjyKPPeJV7UtqOHpLxgFoI
         vpNAYHglC3wYMzdbsiUpJJ66Q7UcpO3iW5wWQ7nd9Mb4FYHcAFyneKM9D01Vs8qtlyvy
         ceU5vxrxrnetT99WkNoCtL/TcKLtGGiixgkScHd044Nb5Yu6QFf0DnGSflXXvbl/oocM
         zbRSCkGOcxbJ9dHe2+6EiJW1J98uMZKBAL4Pyy0Lb0u2L6tlXzRr/orDTIfVmnnFyuE1
         5FLUZsQjbaFqAkpqwvJfm4BLuZq4tXuAV435KXF4RrCMhpS8H0S+OKQuSXrl/qqTRNFE
         gdaQ==
X-Gm-Message-State: APjAAAX/Dm0VtAsGO/T4IEAs4mhVj61ZsBhDGa/4o35ZPUpbF+iKeXJf
        l/Wihxw+AKgAHvMBu8I0rW80ng==
X-Google-Smtp-Source: APXvYqzl0ncoOVQp47dU9bgLqL+1QOknA3M+P7/slzNlmgbdziaq8wjN2LuB06kLgkliQhF59i9EOg==
X-Received: by 2002:a2e:7c12:: with SMTP id x18mr159708ljc.130.1574208776111;
        Tue, 19 Nov 2019 16:12:56 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id u7sm10539769ljj.102.2019.11.19.16.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 16:12:55 -0800 (PST)
Date:   Tue, 19 Nov 2019 16:12:41 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        simon.horman@netronome.com
Subject: Re: [PATCH net-next 1/4] net: sched: add vxlan option support to
 act_tunnel_key
Message-ID: <20191119161241.5b010232@cakuba.netronome.com>
In-Reply-To: <af3c3d95717d8ff70c2c21621cb2f49c310593e2.1574155869.git.lucien.xin@gmail.com>
References: <cover.1574155869.git.lucien.xin@gmail.com>
        <af3c3d95717d8ff70c2c21621cb2f49c310593e2.1574155869.git.lucien.xin@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Nov 2019 17:31:46 +0800, Xin Long wrote:
> @@ -54,6 +55,7 @@ static int tunnel_key_act(struct sk_buff *skb, const struct tc_action *a,
>  static const struct nla_policy
>  enc_opts_policy[TCA_TUNNEL_KEY_ENC_OPTS_MAX + 1] = {

[TCA_TUNNEL_KEY_ENC_OPTS_UNSPEC] = 
	{ .strict_start_type = TCA_TUNNEL_KEY_ENC_OPTS_VXLAN, }

>  	[TCA_TUNNEL_KEY_ENC_OPTS_GENEVE]	= { .type = NLA_NESTED },
> +	[TCA_TUNNEL_KEY_ENC_OPTS_VXLAN]		= { .type = NLA_NESTED },
>  };
>  
>  static const struct nla_policy
> @@ -64,6 +66,11 @@ geneve_opt_policy[TCA_TUNNEL_KEY_ENC_OPT_GENEVE_MAX + 1] = {
>  						       .len = 128 },
>  };
>  
> +static const struct nla_policy
> +vxlan_opt_policy[TCA_TUNNEL_KEY_ENC_OPT_VXLAN_MAX + 1] = {

[TCA_TUNNEL_KEY_ENC_OPT_VXLAN_UNSPEC] =
	{ .strict_type_start = TCA_TUNNEL_KEY_ENC_OPT_VXLAN_UNSPEC + 1,	}

> +	[TCA_TUNNEL_KEY_ENC_OPT_VXLAN_GBP]	   = { .type = NLA_U32 },
> +};
> +
>  static int
>  tunnel_key_copy_geneve_opt(const struct nlattr *nla, void *dst, int dst_len,
>  			   struct netlink_ext_ack *extack)
