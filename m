Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB0A5A0115
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 20:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240272AbiHXSHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 14:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbiHXSHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 14:07:18 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B132A439;
        Wed, 24 Aug 2022 11:07:16 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id z8so2472047edb.0;
        Wed, 24 Aug 2022 11:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:from:to:cc;
        bh=1ptMVCcgWCcBFSWJsXP+IAhY1ErZK6Q+RidWU37Y4N4=;
        b=aZrFvfvzMnUtLsqP7V41QakV8hN05HYa4XI0wfsh1eE/2Q44J7Q+lDaYZmyczMgbFS
         kSZxA+dmIt1HbrdEtKNt+8Axt0EBgG1wnkL0Ka4mkbfGzKeH0rgK39v/JPytHokNlj5E
         JwTqNgQZWe5EjbmIxdVm8kIp2xevmKUbhWaAlhowrWlAm2+J2eWNj4EIPj3CzZWh4mY/
         NH+Y3sDQDMwG7NgOucLpjDDxZj6KSK5Wei8wVqXUqwKmLPKGW9KgyNcqc7opWnm/Y+K1
         5TzlZxzfRx0gRDaInwIF0NXm0RFUEgWltNsH5mxQld4F9V/idGZtck0PLUmm+lVDtk7q
         igYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:x-gm-message-state:from:to:cc;
        bh=1ptMVCcgWCcBFSWJsXP+IAhY1ErZK6Q+RidWU37Y4N4=;
        b=nBobASaxvPI4Fe4SC5Qg8KNPVOVieoMDVFnsbHEM+dGDlU6q1olqY1dCw3zA0jvNSX
         63Q0C+1nrYcvH1Y3vUsgo0rUdw48I4U8k6DybU5cjKu45fplxzrkQBi7NQqvrrxHZvZI
         o5a3e9rukB4LSuZklD9cZ3drTywVFNu+diH5OLrpmpkPgNrAw1PvIZA8pqG4RenhMB5+
         YiqK4R01fkC0rY5sSXx5zxrxq6hCY6WIBSKwOffWOWISGNND1NLXXjHAxFmuJdXlqJ1D
         5C5guk/WqeEAeSsv0JF/tI13c0v9JtO2Er2Kku+EQ5mQ4gJRWbGhq8YvKbayZY/YVmxy
         AqdA==
X-Gm-Message-State: ACgBeo27j6/OXUqm3x4Xa8peUDUXgTjjkzHgfeiLIi7YpB1r15SA9urK
        Z+mka5xdAqrHKG3gJHlfvpbTooP2J8BGAvrEEFs=
X-Google-Smtp-Source: AA6agR45Yfd8ga/MJY9kfIHJ/O1mIVLcZWiaNcK9cgPJ+PHkuCzPUsm9JXr/S5f6gJwgZ0mZjSBhVlQCCuk906dwPmU=
X-Received: by 2002:a05:6402:2792:b0:446:8864:26c1 with SMTP id
 b18-20020a056402279200b00446886426c1mr216306ede.70.1661364435052; Wed, 24 Aug
 2022 11:07:15 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:1f4f:b0:738:5e95:4b25 with HTTP; Wed, 24 Aug 2022
 11:07:13 -0700 (PDT)
In-Reply-To: <20220824111712.5999-1-sunshouxin@chinatelecom.cn>
References: <20220824111712.5999-1-sunshouxin@chinatelecom.cn>
From:   Jay Vosburgh <j.vosburgh@gmail.com>
Date:   Wed, 24 Aug 2022 11:07:13 -0700
Message-ID: <CAAoacNmKa5oM10J6DTLJ6PANmdS8k80Lcxygv_vXd_0DduXM4A@mail.gmail.com>
Subject: Re: [PATCH net-next v2] bonding: Remove unnecessary check
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>
Cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        huyd12@chinatelecom.cn
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/24/22, Sun Shouxin <sunshouxin@chinatelecom.cn> wrote:
> This code is intended to support bond alb interface added to
> Linux bridge by modifying MAC, however, it doesn't work for
> one bond alb interface with vlan added to bridge.
> Since commit d5410ac7b0ba("net:bonding:support balance-alb
> interface with vlan to bridge"), new logic is adapted to handle
> bond alb with or without vlan id, and then the code is deprecated.

I think this could still be clearer; the actual changes relate to the stack of
interfaces (e.g., eth0 -> bond0 -> vlan123 -> bridge0), not what VLAN tags
incoming traffic contains.

The code being removed here is specifically for the case of
eth0 -> bond0 -> bridge0, without an intermediate VLAN interface
in the stack (because, if memory serves, netif_is_bridge_port doesn't
transfer through to the bond if there's a VLAN interface in between).

Also, this code is for incoming traffic, assigning the bond's MAC to
traffic arriving on interfaces other than the active interface (which bears
the bond's MAC in alb mode; the other interfaces have different MACs).
Commit d5410ac7b0ba affects the balance assignments for outgoing ARP
traffic.  I'm not sure that d5410 is an exact replacement for the code this
patch removes.

       -J

>
> Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
> Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
> ---
>  drivers/net/bonding/bond_main.c | 13 -------------
>  1 file changed, 13 deletions(-)
>
> diff --git a/drivers/net/bonding/bond_main.c
> b/drivers/net/bonding/bond_main.c
> index 50e60843020c..6b0f0ce9b9a1 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -1578,19 +1578,6 @@ static rx_handler_result_t bond_handle_frame(struct
> sk_buff **pskb)
>
>  	skb->dev = bond->dev;
>
> -	if (BOND_MODE(bond) == BOND_MODE_ALB &&
> -	    netif_is_bridge_port(bond->dev) &&
> -	    skb->pkt_type == PACKET_HOST) {
> -
> -		if (unlikely(skb_cow_head(skb,
> -					  skb->data - skb_mac_header(skb)))) {
> -			kfree_skb(skb);
> -			return RX_HANDLER_CONSUMED;
> -		}
> -		bond_hw_addr_copy(eth_hdr(skb)->h_dest, bond->dev->dev_addr,
> -				  bond->dev->addr_len);
> -	}
> -
>  	return ret;
>  }
>
> --
> 2.27.0
>
>
