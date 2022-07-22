Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67C0157DA2B
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 08:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbiGVGSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 02:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiGVGSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 02:18:51 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A375466BB9
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 23:18:50 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id c72so1776810edf.8
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 23:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2uD2epaAfxMNuwTRTpPls5Nw8PpUWFQrEFoFuEvhGn0=;
        b=5BVNq20xCgExIi+ptlVrUOuFuwpT6QZSgI7xr6xduWHpw5sJgI7QBY3/BiEKqVluiv
         b2RBFjGCA2oUjyfFM2JbqoRYBGD9Up1zcIFGD6h3NoD2MlElUFQjjevXTfH1WmqW/O1y
         B5Nge7bQcJSaDPvah/6/Y9Q13K+ZgjWSSGZ0/mh5dpaWU3Hhk5mjsV+6U3ncl/tAbnm/
         LGSm1wZJHJvWyig+OHicN/D5ZUXP8DFuTC440y4Cg7nUPyGnxGBeTXrhuVj51SBfryQ4
         HA++R+QWvePDB6vt+xtwA+4wdW4F9m64y7Y3yNuunCMzV5NIFDhH+4RFpdT6W7hG2nSf
         4Gmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2uD2epaAfxMNuwTRTpPls5Nw8PpUWFQrEFoFuEvhGn0=;
        b=zFBoXh3SgywNebwbxKGHOK3kaG6Ej7ck4QE+VYhhLzM0dUSWwvOwuFe2AkO9GOlMhQ
         sVFMz6sk1hsE4zx90pOA9GHbrr9Y3OUo8gFoYGae6AwnxsHbayJxOCoc4P625SFW+xfL
         nOLb/sbzm2BkDmtNVQso3YLoHxqkIhKa+0u/S3SgSermSIj0IoGTSC6J5iBOkLHETDsy
         72IZkHsNwUz7Q/Ym09KLx05O9bSjsVv9UDn9I0tZ7Xxrc58GFJbcloyZlsYv0jI9H/2A
         EK/qNjAw75B/+gOtSXHBtopkYzmZ3A6Ni+giu29d8rEMrrevPPK1BFWAuPzSh2gUKz9v
         DLVg==
X-Gm-Message-State: AJIora/1nG3Tw1zEk329WXU3uiHwZqGgQlt7+tUmKzi/6Ky1L5ZID1yi
        fOsmX5y4PHbt4c3czMVvta7qVQ==
X-Google-Smtp-Source: AGRyM1sMnrN7HcyincnXglfMF2Dm4V3mEN+5IFJ8naZlrkhgeUbYcCTeEQN4I55IbIAbaoE2s0Xszg==
X-Received: by 2002:a05:6402:291c:b0:43b:d177:c59 with SMTP id ee28-20020a056402291c00b0043bd1770c59mr1573641edb.370.1658470729293;
        Thu, 21 Jul 2022 23:18:49 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id en21-20020a17090728d500b0072b342ad997sm1632315ejc.199.2022.07.21.23.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 23:18:48 -0700 (PDT)
Date:   Fri, 22 Jul 2022 08:18:47 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Message-ID: <YtpBR2ZnR2ieOg5E@nanopsycho>
References: <20220720183433.2070122-1-jacob.e.keller@intel.com>
 <20220720183433.2070122-2-jacob.e.keller@intel.com>
 <YtjqJjIceW+fProb@nanopsycho>
 <SA2PR11MB51001777DC391C7E2626E84AD6919@SA2PR11MB5100.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA2PR11MB51001777DC391C7E2626E84AD6919@SA2PR11MB5100.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 21, 2022 at 10:32:25PM CEST, jacob.e.keller@intel.com wrote:
>
>
>> -----Original Message-----
>> From: Jiri Pirko <jiri@resnulli.us>
>> Sent: Wednesday, July 20, 2022 10:55 PM
>> To: Keller, Jacob E <jacob.e.keller@intel.com>
>> Cc: netdev@vger.kernel.org; Jakub Kicinski <kuba@kernel.org>
>> Subject: Re: [net-next PATCH 1/2] devlink: add dry run attribute to flash update
>
><...>
>
>> > struct devlink_region;
>> > struct devlink_info_req;
>> >diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>> >index b3d40a5d72ff..e24a5a808a12 100644
>> >--- a/include/uapi/linux/devlink.h
>> >+++ b/include/uapi/linux/devlink.h
>> >@@ -576,6 +576,14 @@ enum devlink_attr {
>> > 	DEVLINK_ATTR_LINECARD_TYPE,		/* string */
>> > 	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
>> >
>> >+	/* Before adding this attribute to a command, user space should check
>> >+	 * the policy dump and verify the kernel recognizes the attribute.
>> >+	 * Otherwise older kernels which do not recognize the attribute may
>> >+	 * silently accept the unknown attribute while not actually performing
>> >+	 * a dry run.
>> 
>> Why this comment is needed? Isn't that something generic which applies
>> to all new attributes what userspace may pass and kernel may ignore?
>> 
>
>Because other attributes may not have such a negative and unexpected side effect. In most cases the side effect will be "the thing you wanted doesn't happen", but in this case its "the thing you didn't want to happen does". I think that deserves some warning. A dry run is a request to *not* do something.

Hmm. Another option, in order to be on the safe side, would be to have a
new cmd for this...


>
>Thanks,
>Jake
