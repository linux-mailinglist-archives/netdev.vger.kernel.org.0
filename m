Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55DF357F024
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 17:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbiGWPmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 11:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiGWPm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 11:42:29 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5AD1EC7E
        for <netdev@vger.kernel.org>; Sat, 23 Jul 2022 08:42:28 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id g1so8960865edb.12
        for <netdev@vger.kernel.org>; Sat, 23 Jul 2022 08:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yAjOYQ8s08rr1l1qltKSmEfHrH1AlKp/rH/SYxzfoRw=;
        b=bLJ6tJdw8gEMyqnbth4ooa4zuPQ5+YPcZh0TRvZpdfgzne0teVIR9ScJqJuN0u439H
         lDDs9SSrDKbWG3hf/5cXNsJthReg8AIOIeLH9y8BbcoZdTg1BBmvpIovVltO2Wa/6zCl
         OnhsSM9SQIgh4ILuD5inZ4SaFu8lNzI3EmMdos5GSpIWiweJx15PXgH0xbAAXSEEeJhs
         uSV24mM46nT8qoFacVOk6uKwc4+CP4xgnzeyWtgafH1WBIyb4U91/4VnwPBaeAV+PrJr
         2byVmFYxGpml9Ado9jqXdB8H923mcaxkq2wuTsyuc50nI+J3K5q3U3rQQWbBxD4Ju58z
         Ulug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yAjOYQ8s08rr1l1qltKSmEfHrH1AlKp/rH/SYxzfoRw=;
        b=UfV8QKvYLvVWNP8Zjn8IBfzU7qzlsn7MQ+0xyFNurtS616Wzffb24B7UrJOTerQB5l
         zU0mDbX3CQCUWGYIE2UK4m9uDT3j6YVjGWJ5+puaExzQ58ApF3YFY9720Z0cZjvkx35I
         mvGAe5bGmreAlTLntZ2fo/RXv9HSMS7lUAGpIO74bQQfXDpt+rXhwMw0Iit2xsaiKhvT
         0xBEQ4nhpb8tMaWrW/IGAHHGszJhRcoZM/L/rH9kmoreVtppekorGFv+NPz9/zdHs1zu
         tDzQfSZ5iMN0QztcxEAfKHjx8zUjlV6UucHgnIttZxmAiFvFFU/tTV2kH1LJ6rSAPvky
         sLlw==
X-Gm-Message-State: AJIora8D1RrFdAaPD9yar9T85r6UDjwBon1NCG10h2e9a8XLdVpZDV5/
        K47oa2bruyPOO6lV4jNJGcTj+A==
X-Google-Smtp-Source: AGRyM1tFWlFXiLxGOQtLbgb4hfhXvnkvvntdYXo1QEu5TEGwJNaW8nTGVCVCWbX9/D8UVv72WZB63Q==
X-Received: by 2002:aa7:cf13:0:b0:43b:a842:e482 with SMTP id a19-20020aa7cf13000000b0043ba842e482mr4939484edy.192.1658590947494;
        Sat, 23 Jul 2022 08:42:27 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id u17-20020a1709061db100b0072aeda86ac3sm3270136ejh.149.2022.07.23.08.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 08:42:26 -0700 (PDT)
Date:   Sat, 23 Jul 2022 17:42:25 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Message-ID: <YtwW4aMU96JSXIPw@nanopsycho>
References: <20220720183433.2070122-1-jacob.e.keller@intel.com>
 <20220720183433.2070122-2-jacob.e.keller@intel.com>
 <YtjqJjIceW+fProb@nanopsycho>
 <SA2PR11MB51001777DC391C7E2626E84AD6919@SA2PR11MB5100.namprd11.prod.outlook.com>
 <YtpBR2ZnR2ieOg5E@nanopsycho>
 <CO1PR11MB508957F06BB96DD765A7580FD6909@CO1PR11MB5089.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB508957F06BB96DD765A7580FD6909@CO1PR11MB5089.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jul 22, 2022 at 11:12:27PM CEST, jacob.e.keller@intel.com wrote:
>
>
>> -----Original Message-----
>> From: Jiri Pirko <jiri@resnulli.us>
>> Sent: Thursday, July 21, 2022 11:19 PM
>> To: Keller, Jacob E <jacob.e.keller@intel.com>
>> Cc: netdev@vger.kernel.org; Jakub Kicinski <kuba@kernel.org>
>> Subject: Re: [net-next PATCH 1/2] devlink: add dry run attribute to flash update
>> 
>> Thu, Jul 21, 2022 at 10:32:25PM CEST, jacob.e.keller@intel.com wrote:
>> >
>> >
>> >> -----Original Message-----
>> >> From: Jiri Pirko <jiri@resnulli.us>
>> >> Sent: Wednesday, July 20, 2022 10:55 PM
>> >> To: Keller, Jacob E <jacob.e.keller@intel.com>
>> >> Cc: netdev@vger.kernel.org; Jakub Kicinski <kuba@kernel.org>
>> >> Subject: Re: [net-next PATCH 1/2] devlink: add dry run attribute to flash
>> update
>> >
>> ><...>
>> >
>> >> > struct devlink_region;
>> >> > struct devlink_info_req;
>> >> >diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>> >> >index b3d40a5d72ff..e24a5a808a12 100644
>> >> >--- a/include/uapi/linux/devlink.h
>> >> >+++ b/include/uapi/linux/devlink.h
>> >> >@@ -576,6 +576,14 @@ enum devlink_attr {
>> >> > 	DEVLINK_ATTR_LINECARD_TYPE,		/* string */
>> >> > 	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
>> >> >
>> >> >+	/* Before adding this attribute to a command, user space should check
>> >> >+	 * the policy dump and verify the kernel recognizes the attribute.
>> >> >+	 * Otherwise older kernels which do not recognize the attribute may
>> >> >+	 * silently accept the unknown attribute while not actually performing
>> >> >+	 * a dry run.
>> >>
>> >> Why this comment is needed? Isn't that something generic which applies
>> >> to all new attributes what userspace may pass and kernel may ignore?
>> >>
>> >
>> >Because other attributes may not have such a negative and unexpected side
>> effect. In most cases the side effect will be "the thing you wanted doesn't
>> happen", but in this case its "the thing you didn't want to happen does". I think
>> that deserves some warning. A dry run is a request to *not* do something.
>> 
>> Hmm. Another option, in order to be on the safe side, would be to have a
>> new cmd for this...
>> 
>
>I think that the warning and implementation in the iproute2 devlink userspace is sufficient. The alternative would be to work towards converting devlink over to the explicit validation which rejects unknown parameters.. but that has its own backwards compatibility challenges as well.
>
>I guess we could use the same code to implement the command so it wouldn't be too much of a burden to add, but that also means we'd have a pattern of using a new command for every future devlink operation that wants a "dry run". I was anticipating we might want this  kind of option for other commands such as port splitting and unsplitting.
>
>If we were going to add new commands, I would rather we go to the extra trouble of updating all the commands to be strict validation.

I think it is good idea. We would prevent many surprises.

>
>Thanks,
>Jake
