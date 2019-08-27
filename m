Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEEA19DE68
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 09:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbfH0HIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 03:08:12 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51886 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbfH0HIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 03:08:12 -0400
Received: by mail-wm1-f67.google.com with SMTP id k1so1863207wmi.1
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 00:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=K3dR+kYzCpf0LHtg4W8b5/TM1dkZeAuxaiVCsNYOztk=;
        b=QHsI6nONWW5YauGAV+hWB1lnaRgZ2SWxi2vZTigWFhLSzzKpXcGbQ4GD0SxDDdWLHP
         H/oYs3rFaWN7s4HebmnHocxQVXFprTiXhO7rZ9SgFL/+zcH1zJi8yjKjDoGALAwe3Sip
         ygY+yHrInETEqZu4aeEAhPbhmA4nJ984rSvHlbANWoaU/gpu8VditIFIaU9A2cGZkVU5
         xL1ZNvUxe2RFZogU/igc/N1oZdGA3QEWJWR5iGoQG/GwJezvhZyHL4N+3dsUGWgJ19VP
         lnXROpsRkGFc/7ZNABNtjkiTtJwG3Riu69wVg3npmbpPT/JNbimjEdICKF07LMrzm3tB
         44pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=K3dR+kYzCpf0LHtg4W8b5/TM1dkZeAuxaiVCsNYOztk=;
        b=dkzzc3ByGq0tipnW21yNylkdGdwv+sjE7/4ThvfbRQx+njHZfP2n8Yoq6gTbxfWAeS
         css36d0jITFn90Z34cMI9sBc09pB/FTdyk6qhJBDqlQSFBvnfFFJ0ABxPvSXhHxFFeuE
         WsuIDR/Ro6o8ILKsGT29Yw+pS/pIZS799aJS8HAdvaq05LDXqcuydZ47Ulf9S+ylv1bu
         FMSQk1EfLMwOtOV1sWxATHxvWPMC9lxRPYK5YfIYsjSRXFbnSK5aLXnTFlDkfPtgloIL
         0e5gvmL1WQCChODQCScVjsTzYYu4GghwkMeS0a+Sz123rkOSSujA4TSDgET3r1lIMupD
         8jRQ==
X-Gm-Message-State: APjAAAW9GEW117yLVudXl8sk3mH8BVg3+easz3sUw1Nf8JxQnfXsQckw
        cri/UOYohZv/PnwoMXkVrWmw0g==
X-Google-Smtp-Source: APXvYqxILz5eiErst14wmAry2j2Vsp7zECFg8Xr6i5m9i38ktZpGODDnfQHG1rirtAuxqrCXyS2eHg==
X-Received: by 2002:a1c:eb0c:: with SMTP id j12mr25320622wmh.132.1566889690179;
        Tue, 27 Aug 2019 00:08:10 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id f7sm17969307wrf.8.2019.08.27.00.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2019 00:08:09 -0700 (PDT)
Date:   Tue, 27 Aug 2019 09:08:08 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Miller <davem@davemloft.net>
Cc:     jakub.kicinski@netronome.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, netdev@vger.kernel.org,
        sthemmin@microsoft.com, dcbw@redhat.com, mkubecek@suse.cz,
        andrew@lunn.ch, parav@mellanox.com, saeedm@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
Message-ID: <20190827070808.GA2250@nanopsycho>
References: <20190826095548.4d4843fe@cakuba.netronome.com>
 <5d79fba4-f82e-97a7-7846-fd1de089a95b@gmail.com>
 <20190826151552.4f1a2ad9@cakuba.netronome.com>
 <20190826.151819.804077961408964282.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826.151819.804077961408964282.davem@davemloft.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Aug 27, 2019 at 12:18:19AM CEST, davem@davemloft.net wrote:
>From: Jakub Kicinski <jakub.kicinski@netronome.com>
>Date: Mon, 26 Aug 2019 15:15:52 -0700
>
>> Weren't there multiple problems with the size of the RTM_NEWLINK
>> notification already? Adding multiple sizeable strings to it won't
>> help there either :S
>
>Indeed.
>
>We even had situations where we had to make the information provided
>in a newlink dump opt-in when we added VF info because the buffers
>glibc was using at the time were too small and this broke so much
>stuff.
>
>I honestly think that the size of link dumps are out of hand as-is.

Okay, so if I understand correctly, on top of separate commands for
add/del of alternative names, you suggest also get/dump to be separate
command and don't fill this up in existing newling/getlink command.

So we'll have:
CMD to add:
	RTM_NEWALTIFNAME = 108
#define RTM_NEWALTIFNAME       RTM_NEWALTIFNAME

Example msg (user->kernel):
     IFLA_IFNAME eth0
     IFLA_ALT_IFNAME_MOD somereallyreallylongname

Example msg (user->kernel):
     IFLA_ALT_IFNAME somereallyreallylongname
     IFLA_ALT_IFNAME_MOD someotherreallyreallylongname


CMD to delete:
	RTM_DELALTIFNAME,
#define RTM_DELALTIFNAME       RTM_DELALTIFNAME

Example msg (user->kernel):
     IFLA_IFNAME eth0
     IFLA_ALT_IFNAME_MOD somereallyreallylongname

	
CMD to get/dump:
        RTM_GETALTIFNAME,
#define RTM_GETALTIFNAME       RTM_GETALTIFNAME

Example msg (kernel->user):
     hdr (with ifindex)
     IFLA_ALT_IFNAME_LIST (nest)
        IFLA_ALT_IFNAME somereallyreallylongname
        IFLA_ALT_IFNAME someotherreallyreallylongname

Correct?	
