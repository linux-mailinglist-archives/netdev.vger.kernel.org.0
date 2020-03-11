Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9F7181249
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 08:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbgCKHrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 03:47:11 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:53358 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgCKHrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 03:47:11 -0400
Received: by mail-wm1-f45.google.com with SMTP id 25so933729wmk.3
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 00:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cVIeeWX2Dn8ox2taKL8D7lPhN2yGhac8uborQquV7Vs=;
        b=t3qm6R4zv7lVkZBaAwkiFxtEqQHukNV0wbOlee7r6pIbTMLwxLWMhgH6nSiIeF1vva
         r8trSIlp9Wjh7TulcnSMY41IVcL7PQW2Bh2fVYj/rVlx4pEd8iVuHZHWWkfgoP9pYXbA
         xPak5DmunNhNhxl70SH9v3fOOLtu52pIWBCtXzJETiQysAYr+jtcIVfEXzhVM2AJsxqf
         9W38/wi0D4r0ND0W5rjexrYfvGLNWpJeIcn003lYuy2AlAR3SZUZ3UxBJtia2YZrZLO3
         vouPy7QYAkcV4YLecDn/vKQXP5zAQyXizOzca3qf5gecfZrB7SvOTnADkvV/3hZx6CZi
         vG8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cVIeeWX2Dn8ox2taKL8D7lPhN2yGhac8uborQquV7Vs=;
        b=Wf3hvz0xUQFMhGjlfAaNe7BLH7riC+Of2VILGDjT2PXmgTSg3aB1SVjqXUynIZtlTc
         XDjEXwOu4N0yZzvqKgolavihLO0M0DG7JNXDUNLm0JT00xFdYRBsQVzuAgwl7RaigoSp
         +MOAX++HHcpRqCXMe6za5p1qEt2Lu1WxzK1CjSaPSEvu5Q33OFLROelqOC71iBs0oSe3
         FrZDtgn3Pb2T96YAYARRsixbWoCTPHyhmND8Yxl3jegA2f9FSNxP08tKcGg/7XOme9JE
         SS+BanvNkP1IWtVHpww610TZyybxnYT56hmUve4W1A9UcweLSTAgW6cJbiwx+C3VkVAF
         SpTA==
X-Gm-Message-State: ANhLgQ0rJ+td60KXLzAjh3v3W7LiVya7QQwO+GVQrA17R92woa5/uaXo
        TpWFvt9JkDUMRb1SP1S1jTbIVfDJaP8=
X-Google-Smtp-Source: ADFU+vtcDtjlTIB1mU307cNhKw2nftdiqXtfnl5BzypYgagvlGox0Eaxlqv+PpB57fU/D/pHj7Kzvw==
X-Received: by 2002:a1c:5443:: with SMTP id p3mr2147653wmi.149.1583912829563;
        Wed, 11 Mar 2020 00:47:09 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id q72sm7673310wme.31.2020.03.11.00.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 00:47:09 -0700 (PDT)
Date:   Wed, 11 Mar 2020 08:47:08 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        mlxsw@mellanox.com
Subject: Re: [patch iproute2/net-next v2] tc: m_action: introduce support for
 hw stats type
Message-ID: <20200311074708.GA2209@nanopsycho>
References: <20200309155402.1561-1-jiri@resnulli.us>
 <1a44786f-bffd-213f-fe13-ca43845c5420@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a44786f-bffd-213f-fe13-ca43845c5420@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Mar 11, 2020 at 12:44:42AM CET, dsahern@gmail.com wrote:
>On 3/9/20 9:54 AM, Jiri Pirko wrote:
>> @@ -24,6 +25,27 @@ enum {
>>  					 * actions stats.
>>  					 */
>>  
>> +/* tca HW stats type
>> + * When user does not pass the attribute, he does not care.
>> + * It is the same as if he would pass the attribute with
>> + * all supported bits set.
>> + * In case no bits are set, user is not interested in getting any HW statistics.
>> + */
>> +#define TCA_ACT_HW_STATS_TYPE_IMMEDIATE (1 << 0) /* Means that in dump, user
>> +						  * gets the current HW stats
>> +						  * state from the device
>> +						  * queried at the dump time.
>> +						  */
>> +#define TCA_ACT_HW_STATS_TYPE_DELAYED (1 << 1) /* Means that in dump, user gets
>
>really long names for attributes.
>
>
>> +static void print_hw_stats(const struct rtattr *arg)
>> +{
>> +	struct nla_bitfield32 *hw_stats_type_bf = RTA_DATA(arg);
>> +	__u8 hw_stats_type;
>> +	int i;
>> +
>> +	hw_stats_type = hw_stats_type_bf->value & hw_stats_type_bf->selector;
>> +	print_string(PRINT_FP, NULL, "\t", NULL);
>> +	open_json_array(PRINT_ANY, "hw_stats");
>> +
>> +	for (i = 0; i < ARRAY_SIZE(hw_stats_type_items); i++) {
>> +		const struct hw_stats_type_item *item;
>> +
>> +		item = &hw_stats_type_items[i];
>> +		if ((!hw_stats_type && !item->type) ||
>> +		    hw_stats_type & item->type)
>> +			print_string(PRINT_ANY, NULL, " %s", item->str);
>
>the stats type can be both delayed and immediate?

Yes, if offloaded to 2 drivers, each supporting different stats.


>
>> +	}
>> +	close_json_array(PRINT_JSON, NULL);
>> +}
>> +
>> +static int parse_hw_stats(const char *str, struct nlmsghdr *n)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(hw_stats_type_items); i++) {
>> +		const struct hw_stats_type_item *item;
>> +
>> +		item = &hw_stats_type_items[i];
>> +		if (matches(str, item->str) == 0) {
>> +			struct nla_bitfield32 hw_stats_type_bf =
>> +					{ item->type,
>> +					  item->type };
>> +			addattr_l(n, MAX_MSG, TCA_ACT_HW_STATS_TYPE,
>> +				  &hw_stats_type_bf, sizeof(hw_stats_type_bf));
>
>that is not human friendly. how about something like:
>
>                        struct nla_bitfield32 hw_stats_type_bf = {
>                                .value    = item->type,
>                                .selector = item->type
>                        };

Okay.



>
>with a line between the declaration and code.
>
>and "disabled" corresponds to 0 which does not align with a
>TCA_ACT_HW_STATS_TYPE_  so why send it

It is a bitfield. So 0 means no bit is set, therefore disabled.

