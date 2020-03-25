Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF3B3192F0C
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 18:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgCYRUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 13:20:41 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54979 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727320AbgCYRUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 13:20:41 -0400
Received: by mail-wm1-f68.google.com with SMTP id c81so3351045wmd.4
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 10:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QLVI8zNSxLrIxX34m4YI2cXgsrHOX77w+svMWnf5/Qc=;
        b=Cbgcy5r960teBvyqrVmQ00sl/OQrzmo0yYQv+HbcgasKXOHsNkgVzFXjdjHB/sfkkd
         EfbquMVzZn/3geDAHYbG4Ykw9rmnW3JxqAC6plBV0TDyl+TUECaplYfX8tSLoaiTojfP
         +fpr9tk5UL0BsRsa5pa7eO8BPjmU2fP5QTF0Z5OX3pJiF+VReM/J0EqAIKFcclcoUUy7
         8QcfAjp1XkTcewiESeHWwkmBcUnrjkdwFWeg3BQoSrWY95URz3r58/f05mJOQlrUbODR
         CFjLTUCTKXxFz/3F+SFjOIJ16Io3OH+ol32CFlophP2KPAWlfmARpI0LFjPs7KP8OOSX
         OkKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QLVI8zNSxLrIxX34m4YI2cXgsrHOX77w+svMWnf5/Qc=;
        b=i0XuWD0kmfwol6SrNNWpSAJMo5nj65egGeOOjyeiFoiwG2jSpy4SC0n/Nd8jbO0d4W
         vz6zdq+MOwN/YHxiqvN6SEQaLXfpHx1KQMjvyF3UbbIFXR5zvzqopW5mFJFjJyBCc3rH
         /erdQUa4rarHxmfSTUX8AUqB0+SkuC2VWXffZi5AqYzhDAVWpK2QJg1S6qOqMUfVpbX0
         Xyfyz31JbRUNr7E8+jSqADTebxQbUDnC3U46QGjkB59G6RQPNnOJUERjE7hhHaF48jwa
         vrDDkWR9FSPyAbwA8/GYWUIVy9/7GWhzOIYFzfI1xo6Mj4NuhVW4ZZ4DbUHE2trSLCjF
         i7Ng==
X-Gm-Message-State: ANhLgQ1hCqtdtnhSPtS50UTWYRVgfykNAuUcFxslOGS3pZPBTrZlJBWF
        ba1+ovAhAqycb/gO6PcQvDvbeg==
X-Google-Smtp-Source: ADFU+vufnzsE5fqlRLNc1x8i/NusCRtbtfPH0DHcXCGVXF8FGvDGFrXDN/8jQ58VjP0DyCuYrfpWAw==
X-Received: by 2002:a1c:ba04:: with SMTP id k4mr4511775wmf.165.1585156837826;
        Wed, 25 Mar 2020 10:20:37 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id b5sm34032164wrj.1.2020.03.25.10.20.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 10:20:37 -0700 (PDT)
Date:   Wed, 25 Mar 2020 18:20:36 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 08/10] devlink: implement DEVLINK_CMD_REGION_NEW
Message-ID: <20200325172036.GC11304@nanopsycho.orion>
References: <20200324223445.2077900-1-jacob.e.keller@intel.com>
 <20200324223445.2077900-9-jacob.e.keller@intel.com>
 <20200325164622.GZ11304@nanopsycho.orion>
 <20200325101804.09db32af@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325101804.09db32af@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Mar 25, 2020 at 06:18:04PM CET, kuba@kernel.org wrote:
>On Wed, 25 Mar 2020 17:46:22 +0100 Jiri Pirko wrote:
>> >+	err = region->ops->snapshot(devlink, info->extack, &data);
>> >+	if (err)
>> >+		goto err_decrement_snapshot_count;
>> >+
>> >+	err = __devlink_region_snapshot_create(region, data, snapshot_id);
>> >+	if (err)
>> >+		goto err_free_snapshot_data;
>> >+
>> >+	return 0;
>> >+
>> >+err_decrement_snapshot_count:
>> >+	__devlink_snapshot_id_decrement(devlink, snapshot_id);
>> >+err_free_snapshot_data:  
>> 
>> In devlink the error labers are named according to actions that failed.
>
>Can we leave this to the author of the code to decide?

Well, if you look at 1 .c file, the reader should see one style. So...

