Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2DFD180C93
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 00:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbgCJXoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 19:44:46 -0400
Received: from mail-qt1-f182.google.com ([209.85.160.182]:36093 "EHLO
        mail-qt1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727702AbgCJXoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 19:44:46 -0400
Received: by mail-qt1-f182.google.com with SMTP id m33so301192qtb.3
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 16:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=V2fuwJgfT+qheE3ekz7/KHC2YOqKEOdSVq3RIQMeP14=;
        b=l+K1gZrg4TG85rYWTA8ifI1kBKIHdmkW2bQRZYbHvssu70RiJbI4MnuMiKTF3VqkBI
         5oEvkjLqnueYvaKV2cFSjEWrDkrOVpvgCngjD186dgzt2V0YFJtsYgYSVUOXh0thks3b
         02SVOYXmaiHgq0oiAd6yWyjgAQPtZrVusV9+ki390rvZPDy8oRCY5rAhyZ7kPnyFZ/do
         WJvqaxEaQ2AWuQQU0+hXgz8u1mcx4ue3iH/Lz6aHsdhx4AZBAhmBmUaAJYhp4BzPQ8z7
         81ONOoiBKdL/k90kPzmbiL2K5RE4DlMHMZbZYJAcq2Y2XtwUPrZgLYuTJWs+cdJ3Snz1
         k48w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V2fuwJgfT+qheE3ekz7/KHC2YOqKEOdSVq3RIQMeP14=;
        b=TrxxLrjZRQr4/mPxqnGpiwYjyYfbjvATuzXuCRz92gHkpfb5GFZ983rsEXixrqkS4F
         1gRERm8Wa4DLHzHvsCK7/E0H9bY9oLq4Q3BtOyEL81CT0z1vRzgWdLsfBAsyz8s/M2iv
         7kR9P2fEZpUV9x+W27sEiS1MD1YzOHk9E4wUFvAuzVQfvsaUSkm8DvCqtPnN6GhqrHAn
         Wzmy+uoSSMNUQj6XKwsV/4h1eQ+hOSCx377SiGoBQP6dH1vw6jJsULAnRa98dgLPIh1p
         ui0lTA5BPTofz9EWALnWTBSCdt+OhdEnj7OQXL7hGKZkC4jpsrmomnpOAGxz42F4yym2
         GGNg==
X-Gm-Message-State: ANhLgQ0QVTQJsnH11wOqr/xoFsK41mfz4z9Lh9TuJV0rOatOyfTFl2Pb
        C8aRu8I+SYX/o1xhfS894p4=
X-Google-Smtp-Source: ADFU+vspdA2jG1P7xSITzoQjLwoYhdU/Bk8UVahG4u0aLnrF+nmUsrHJcXJrHC8aAY7wmT9AXGDTuA==
X-Received: by 2002:ac8:5448:: with SMTP id d8mr355343qtq.205.1583883885327;
        Tue, 10 Mar 2020 16:44:45 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:b876:5d04:c7e4:4480? ([2601:282:803:7700:b876:5d04:c7e4:4480])
        by smtp.googlemail.com with ESMTPSA id j17sm25426077qth.27.2020.03.10.16.44.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 16:44:44 -0700 (PDT)
Subject: Re: [patch iproute2/net-next v2] tc: m_action: introduce support for
 hw stats type
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, mlxsw@mellanox.com
References: <20200309155402.1561-1-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1a44786f-bffd-213f-fe13-ca43845c5420@gmail.com>
Date:   Tue, 10 Mar 2020 17:44:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200309155402.1561-1-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/20 9:54 AM, Jiri Pirko wrote:
> @@ -24,6 +25,27 @@ enum {
>  					 * actions stats.
>  					 */
>  
> +/* tca HW stats type
> + * When user does not pass the attribute, he does not care.
> + * It is the same as if he would pass the attribute with
> + * all supported bits set.
> + * In case no bits are set, user is not interested in getting any HW statistics.
> + */
> +#define TCA_ACT_HW_STATS_TYPE_IMMEDIATE (1 << 0) /* Means that in dump, user
> +						  * gets the current HW stats
> +						  * state from the device
> +						  * queried at the dump time.
> +						  */
> +#define TCA_ACT_HW_STATS_TYPE_DELAYED (1 << 1) /* Means that in dump, user gets

really long names for attributes.


> +static void print_hw_stats(const struct rtattr *arg)
> +{
> +	struct nla_bitfield32 *hw_stats_type_bf = RTA_DATA(arg);
> +	__u8 hw_stats_type;
> +	int i;
> +
> +	hw_stats_type = hw_stats_type_bf->value & hw_stats_type_bf->selector;
> +	print_string(PRINT_FP, NULL, "\t", NULL);
> +	open_json_array(PRINT_ANY, "hw_stats");
> +
> +	for (i = 0; i < ARRAY_SIZE(hw_stats_type_items); i++) {
> +		const struct hw_stats_type_item *item;
> +
> +		item = &hw_stats_type_items[i];
> +		if ((!hw_stats_type && !item->type) ||
> +		    hw_stats_type & item->type)
> +			print_string(PRINT_ANY, NULL, " %s", item->str);

the stats type can be both delayed and immediate?

> +	}
> +	close_json_array(PRINT_JSON, NULL);
> +}
> +
> +static int parse_hw_stats(const char *str, struct nlmsghdr *n)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(hw_stats_type_items); i++) {
> +		const struct hw_stats_type_item *item;
> +
> +		item = &hw_stats_type_items[i];
> +		if (matches(str, item->str) == 0) {
> +			struct nla_bitfield32 hw_stats_type_bf =
> +					{ item->type,
> +					  item->type };
> +			addattr_l(n, MAX_MSG, TCA_ACT_HW_STATS_TYPE,
> +				  &hw_stats_type_bf, sizeof(hw_stats_type_bf));

that is not human friendly. how about something like:

                        struct nla_bitfield32 hw_stats_type_bf = {
                                .value    = item->type,
                                .selector = item->type
                        };

with a line between the declaration and code.

and "disabled" corresponds to 0 which does not align with a
TCA_ACT_HW_STATS_TYPE_  so why send it
