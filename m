Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5A31BF52
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 00:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfEMWBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 18:01:08 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42015 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbfEMWBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 18:01:07 -0400
Received: by mail-pg1-f193.google.com with SMTP id 145so7454476pgg.9;
        Mon, 13 May 2019 15:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=BmohReTs8oe9mx36kGEB4VnDpcgr/j26VHR2MYQ6DXc=;
        b=Ju4mEqg8x5eYk6CHoWmkkEfGCg7glF/eJ8cLf3NnG25GPVs9B9/psWZdZWH0Z2S7C3
         zz5mZ6JLp+tIFy6KJHdOtQzMJaGn278yLc2K79fcb/bZhgEz2GNOT7IhC40LbtBGGU84
         IpS7AUKD5pgT3cSTg14JOTk48rIXnqAZL5QhUSIzFe8aH51Ti54BG64SLU9fx1dGhhqW
         pflESkGO1KdHsf2TYVyLIlFY021oxyEbi1rlpM0BnVUJniWtGFq65e1YAQpw4L9jWdjY
         1AVe1WQAyQ6VaTs17k7fMnAT11oitfyiM96miZe3FhB7u5Q+NA4iFtEFKDc0/CrLAS8d
         aWPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BmohReTs8oe9mx36kGEB4VnDpcgr/j26VHR2MYQ6DXc=;
        b=YTyBMKoGmCIPGv2qN+m+CaQYJI/7UEsKPnxxwDjcR3UaDuu8vUEwiuf91kZXesakJv
         XsQNf1p4Y3fOdZHihd2Z1jeBGzIiV6QbTb8UUQH2WkNKjPyoPserdRtiH0aZZNeXfJns
         jueOZfC/VZOasl8MXwHtuY4VuDA64mQFi56YrsSIWE+BOXfBltKjbFOkFjnNN+J554ST
         AlKE4BUY7MmlcS3qhIqN/OHhe60MdbDxvFV7ncblEyypKX50CkljF3ZJlBzf11Z4xmOn
         nFkR/dTWf7m04pKbDeFh70zXCYuYytb5d8oKILEL2ImnMK91Wnyhht1B5Lr9P6KGVets
         7qGA==
X-Gm-Message-State: APjAAAXe26yl1KBWNmmbHvocnsWZQU70CnpnUd3hFbpSNJEGVbnnhvZm
        xFIL1/U9+bht3WsTqS1DBEc=
X-Google-Smtp-Source: APXvYqy81lzMO2bK11iOnpqqTUPG1iup+4E7SDIPadrSejRVtOHbQHeJx+VL6icdi3oI011wIa7fdg==
X-Received: by 2002:a63:cf0d:: with SMTP id j13mr35216766pgg.433.1557784867236;
        Mon, 13 May 2019 15:01:07 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:5dd:49d5:5580:adf5? ([2601:282:800:fd80:5dd:49d5:5580:adf5])
        by smtp.googlemail.com with ESMTPSA id q27sm10385684pfg.49.2019.05.13.15.01.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 15:01:06 -0700 (PDT)
Subject: Re: getneigh: add nondump to retrieve single entry
To:     mcmahon@arista.com, davem@davemloft.net, roopa@cumulusnetworks.com,
        christian@brauner.io, khlebnikov@yandex-team.ru,
        lzgrablic@arista.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mowat@arista.com, dmia@arista.com
References: <mcmahon@arista.com> <20190513160335.24128-1-mcmahon@arista.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d05e56d5-2677-3c03-7a25-df2ca2681a75@gmail.com>
Date:   Mon, 13 May 2019 16:01:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190513160335.24128-1-mcmahon@arista.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/13/19 10:03 AM, mcmahon@arista.com wrote:
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 30f6fd8f68e0..981f1568710b 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> +static int neigh_find_fill(struct neigh_table *tbl, const void *pkey,
> +                           struct net_device *dev, struct sk_buff *skb, u32 pid,
> +                           u32 seq)
> +{
> +	struct neighbour *neigh;
> +	int key_len = tbl->key_len;
> +	u32 hash_val;
> +	struct neigh_hash_table *nht;
> +	int err;

reverse xmas tree ordering

...

> +static int neigh_get(struct sk_buff *skb, struct nlmsghdr *nlh)
> +{
> +	struct net *net = sock_net(skb->sk);
> +	struct ndmsg *ndm;
> +	struct nlattr *dst_attr;
> +	struct neigh_table *tbl;
> +	struct net_device *dev = NULL;
> +
> +	ASSERT_RTNL();
> +	if (nlmsg_len(nlh) < sizeof(*ndm))
> +		return -EINVAL;
> +
> +	dst_attr = nlmsg_find_attr(nlh, sizeof(*ndm), NDA_DST);
> +	if (dst_attr == NULL)
> +		return -EINVAL;
> +
> +	ndm = nlmsg_data(nlh);
> +	if (ndm->ndm_ifindex) {
> +		dev = __dev_get_by_index(net, ndm->ndm_ifindex);
> +		if (dev == NULL)
> +			return -ENODEV;
> +	}
> +
> +	read_lock(&neigh_tbl_lock);

this patch is clearly for a MUCH older kernel than 5.2 (like 3.18
maybe?) as that lock no longer exists.

> +	for (tbl = neigh_tables; tbl; tbl = tbl->next) {
> +		struct sk_buff *nskb;
> +		int err;
> +
> +		if (tbl->family != ndm->ndm_family)
> +			continue;

Use neigh_find_table.

You need to update the patch to top of net-next tree and re-work the
locking. Run tests with RCU and lock debugging enabled to make sure you
have it right.
