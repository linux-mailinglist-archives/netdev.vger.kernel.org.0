Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 594ECD2E3B
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 18:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfJJQAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 12:00:00 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39348 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfJJP77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 11:59:59 -0400
Received: by mail-wr1-f67.google.com with SMTP id r3so8571443wrj.6
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 08:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Adc/sOVJH420jCtNWHunWz9Zz5Bs27+Re6hl25uBUac=;
        b=FrhugCb6PxgrlFvoTyqdF5uU85qAQvkZ21Q1uoHf7rTogkJLrl/87lUct1q9kFdszG
         6nl2Imk+ENDNnOVle8j84pgpeSQw0a7WYgp2uJijQKx+ylW3yUwLDwZB7kTtWvR92pRh
         3rxiUEdvVaS8RRXuWxmtkv+/EcQOcmKhgt0YvT8wlttQ7vJ9R9ZRebq9fXNRZ75lgX+C
         j3E+h1CdhRXJexTzHOEeG+mQCRvGx/6NL8vGBjWIa3H63HnOUbAbe18DRB5owU6P3SDD
         ZmNIhDnWzxarbykp1O/73oRgGmF36CYKTlSTfA1RnXaYpMMrvsHnzOa7wBId/XmJiqUx
         WHTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Adc/sOVJH420jCtNWHunWz9Zz5Bs27+Re6hl25uBUac=;
        b=sILYb9PdBeZ6CMdzzV0LYS2Jmc/sJPO6Fd1Zw6g+Dc4TXi08flpQiXA/XerXBBJLlB
         6lytchlggcl050FoB+q/ZsNNFi6Cm+ESp+YfPCNZj4/fA3LIFHoTdQrqq84R88oVVswq
         Tv+9mqGi68fCsi+wgkxGM4UbniY2Oel/qFXP9NgTXVTU1pQ1ct8VbvxEVgWecaQ2znzz
         SADEwjH5q6+t4pC9jLNXSorO7pdkve3kI3D9iGXdDDZb30QG9w4GApIR4F1SH6gDkjBe
         Xi6MGfiL02rgnQll/fcjUZb5m/0P4ufXkhQV1qwXkhkKg5wMiUmIcTBUj2CaErjD4zmp
         2AXA==
X-Gm-Message-State: APjAAAUaz1p0Aiw33mFPBHvEy7EsBv72iUqtLpkjmLyTfFWuuZdO5tQd
        A7Mu6dy/yokzV+8pi/zBj8GyPA==
X-Google-Smtp-Source: APXvYqxulKgl1eYSjDtsgm6XD1L8iWCXTboIJrqEk/6dSmAPptkMZ0/lnzQhqANwiRSA7IWD8BWswQ==
X-Received: by 2002:adf:f90d:: with SMTP id b13mr9033535wrr.316.1570723196609;
        Thu, 10 Oct 2019 08:59:56 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id x16sm3967515wrl.32.2019.10.10.08.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 08:59:56 -0700 (PDT)
Date:   Thu, 10 Oct 2019 17:59:55 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v7 12/17] ethtool: provide link settings with
 LINKINFO_GET request
Message-ID: <20191010155955.GB2901@nanopsycho>
References: <cover.1570654310.git.mkubecek@suse.cz>
 <1568f00bf7275f1a872c177e29d5800cd73e50c8.1570654310.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1568f00bf7275f1a872c177e29d5800cd73e50c8.1570654310.git.mkubecek@suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 09, 2019 at 10:59:37PM CEST, mkubecek@suse.cz wrote:

[...]

>+/* prepare_data() handler */

Not sure how valuable are comments like this...


>+static int linkinfo_prepare(const struct ethnl_req_info *req_base,
>+			    struct ethnl_reply_data *reply_base,
>+			    struct genl_info *info)
>+{
>+	struct linkinfo_reply_data *data =
>+		container_of(reply_base, struct linkinfo_reply_data, base);

A helper would be nice for this. For req_info too.


>+	struct net_device *dev = reply_base->dev;
>+	int ret;
>+
>+	data->lsettings = &data->ksettings.base;
>+
>+	ret = ethnl_before_ops(dev);

"before_ops"/"after_ops" sounds odd. Maybe:
ethnl_ops_begin
ethnl_ops_complete

To me in-line with ethtool_ops names?

I guess you don't want the caller (ethnl_get_doit/ethnl_get_dumpit)
to call this because it might not be needed down in prepare_data()
callback, right?


>+	if (ret < 0)
>+		return ret;
>+	ret = __ethtool_get_link_ksettings(dev, &data->ksettings);
>+	if (ret < 0 && info)
>+		GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
>+	ethnl_after_ops(dev);
>+
>+	return ret;
>+}

[...]


>+const struct get_request_ops linkinfo_request_ops = {
>+	.request_cmd		= ETHTOOL_MSG_LINKINFO_GET,
>+	.reply_cmd		= ETHTOOL_MSG_LINKINFO_GET_REPLY,
>+	.hdr_attr		= ETHTOOL_A_LINKINFO_HEADER,
>+	.max_attr		= ETHTOOL_A_LINKINFO_MAX,
>+	.req_info_size		= sizeof(struct linkinfo_req_info),
>+	.reply_data_size	= sizeof(struct linkinfo_reply_data),
>+	.request_policy		= linkinfo_get_policy,
>+	.all_reqflags		= ETHTOOL_RFLAG_LINKINFO_ALL,
>+
>+	.prepare_data		= linkinfo_prepare,

Please have the ops with the same name/suffix:
	.request_policy		= linkinfo_reques_policy,
	.prepare_data		= linkinfo_prepare_data,
	.reply_size		= linkinfo_reply_size,
	.fill_reply		= linkinfo_fill_reply,

Same applies of course to the other patches.


>+	.reply_size		= linkinfo_size,
>+	.fill_reply		= linkinfo_fill,
>+};

[...]
