Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F58B2F90A
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 11:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfE3JLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 05:11:33 -0400
Received: from mout.web.de ([212.227.17.11]:47575 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbfE3JLd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 05:11:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1559207486;
        bh=mhWdBvAm70EzVnomZihjH1xuc8nngI6HhLWHshUr+NI=;
        h=X-UI-Sender-Class:To:Cc:References:Subject:From:Date:In-Reply-To;
        b=sk0thWvptHZtjnTQp/iZ4ibkR2H8y0VDhAffTMJy94yVHYx5SxNrslCWrc+qwfWqX
         Gs8WYEajeiA68rUo/wuS82pA/+5pyf0sDSLw4DtN99QvXvTHyZgfKZb+0zDFJjZO70
         IW0ijxqGXFGEmQLVmoRwxMEC4xOl7nYNzzDMIVFk=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.4] ([78.48.143.243]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0Mb90x-1hBi6Q3rZL-00Kixd; Thu, 30
 May 2019 11:11:26 +0200
To:     Josh Hunt <johunt@akamai.com>, David Ahern <dsahern@gmail.com>,
        netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <1556674718-5081-1-git-send-email-johunt@akamai.com>
Subject: Re: [PATCH v2] ss: add option to print socket information on one line
From:   Markus Elfring <Markus.Elfring@web.de>
Openpgp: preference=signencrypt
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <86d8b203-69bd-e466-715d-959368685839@web.de>
Date:   Thu, 30 May 2019 11:11:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1556674718-5081-1-git-send-email-johunt@akamai.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:JtyYEaodFcAKwncmrE0Jq2jxHF6/9JhY4M6QHv9XCBm/7qdBshn
 KjCO+i9rwpCp1TbcVeAxlb6Kr1aCxpvG53B2akpaeTKuUNDPndhoYOd4k6ULjRaX6Xa9iZq
 PF60wkkheY9SZ6uwQ8MIKnF4nUkmNg5YtXsAh7P5NKrAj8bh2IaSHpsoMry1ujYslBimQmA
 tlml39SQVx4QVlko9Bwfw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:WTlLPHc4dDE=:yHZI2I8SaX/+3KN7EPi240
 PKwVpdHpRDGziNCbCOhEeIxjt1ZIsJwXyOFcQi9jJx8lDKBnDid/jNLvWz3u2CWAY5kk1nA85
 MaLO3Haj2fZ+DkA0de/z9webp+grGupJhxxqXbzZrIIaNAAjKvUDigs1ye4Fg8on4UYXKQ5yN
 QUezCXKnwI6Wkfv9sEm8ObBegYnvQWz2JG9xMupqsWPgOFxbgfzU7rK9YrQm+aayXWVq0giKP
 4pYkavog9/MXs29yhxk0uQ+R+vw3IzxGOERln/OgaFvgUePfC80cin5NIGdXTXuzHTMFARwgz
 YfDkBVL90by1M8zlJkoN9qGt7kW9ccxi0w8ZKtHw6Ti1RTMmeRPUuE9NICxj8DMQUcTnkUD/S
 88qcAZ8/E/rMZsFnq/hzO7YpLFyhw9qocAYW/o142FFGBlic3xJ63Bwni5zWyXUqu9rpEGcge
 HQL3Ekg0Mj+P9wGrHIQJ4T/x1uQeTJ3/CyV08xU908QIWG8I99E9nx8fyBiHfxu3ZZ4gGUvCs
 GOiYJBjPHO2IAf0fe/UN9yS8lbAv9XJOc61TRP/D8wUFt+U/wSg0uheflsOxI0f/+V82KxvQn
 WJxT6uHrqpj2FVS3DIqm6qX6YDFkhq9xZ6QGmgkyeVDSAJWFofNtAhrpWcnC8ZqrHKDm+wZ5c
 GYY3hpi31BenAToxTM3kptAUucTM2CI/3CphbWHY1mSE1wZDgsmquBnInrPeGBr3EggElYFaJ
 HrGkYWeONMwR9g04ZQ2buIlQTooBMGuYBItxtQ40KAW1HJlBOuIfDaPpKb7VjXnEp3Yevgw4y
 BKdrZevGV1/OKK76b2ikPrddnLm7kt5NBHfJ+YboYpBkszFk76QLsdBdrPPs8r2p64MTkakOg
 KF87BRSS051Q5Wdf1K+kYNCeXdM7wulJUnPPGWF6JxGEfYlk2b4kg65RUh3TYkE29csWIEGSr
 7j84Ty9QDyLhrCRQf2uVkNB865ANhFu24DwTa2fGXH1oZtqG6EoG4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This software update caught also my development attention a moment ago.


> +++ b/misc/ss.c
> @@ -3973,7 +3975,10 @@ static int packet_show_sock(struct nlmsghdr *nlh,=
 void *arg)
>
>  	if (show_details) {
>  		if (pinfo) {
> -			out("\n\tver:%d", pinfo->pdi_version);
> +			if (oneline)
> +				out(" ver:%d", pinfo->pdi_version);
> +			else
> +				out("\n\tver:%d", pinfo->pdi_version);
>  			out(" cpy_thresh:%d", pinfo->pdi_copy_thresh);
>  			out(" flags( ");
>  			if (pinfo->pdi_flags & PDI_RUNNING)

I would find it nicer to use the ternary operator here.

+			out(oneline ? " ver:%d" : "\n\tver:%d",
+			    pinfo->pdi_version);


How do you think about to use more succinct statement variants?

Regards,
Markus
