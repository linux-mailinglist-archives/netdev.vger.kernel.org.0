Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 303D617F4CC
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 11:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgCJKOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 06:14:54 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50478 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbgCJKOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 06:14:49 -0400
Received: by mail-wm1-f65.google.com with SMTP id a5so670048wmb.0
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 03:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2lTu4M4IFqCOffGsw3frVQnjVFNSoPWbt3mWv8HREvU=;
        b=AxxhQPYOIWvwd4Zk9vam9EkiWIPxVtJL4y0ad6Y2pHXcclUL0GBr/OKRJ0Dji0wRc+
         dNj5H6qsweM5mDgVocdZC0Lgj/286yncMnv0YzpsNI8EC9uDVg5v50cDLgGe/S9ua+zu
         b7/PWJ8bnuDG6jPR7zOKTyD61mhj+4lG0PMLkk5YgVBtLBAcoK4XZe3SckQbbOrhV63q
         eUpb/7WM1Lk7cu66GV2Kb9F/1Wu4t+B/Fa59jMG8nBtXAPm+DT4Riq26hLeRS2c5k6Gq
         iyNUiMYwwSrK5sdgDUsAGerGaBYDfw8+6/X1SXhWHGxzXChBNgpkA3Tcky9wj/kFYvD3
         pcvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2lTu4M4IFqCOffGsw3frVQnjVFNSoPWbt3mWv8HREvU=;
        b=ks7B9ORgEKvK1gBSCm72tqcV36f3RvuZU4up0QXLhlBj40rh+Pvspic2F9lnPzYBKa
         RKcuROYX4XLCjkBHwov67qlcKjzwuBGHeciFn5TQTjvQhwMO7EyY+VttQxm/T+P1wLn2
         Bgei3/UU08WL2O+BuwBEzMHzm6brGWtgHXQN/1YXamMmZFpyBg1g6QdTWPU2/Yjum9dm
         XJW26CQbQMMn9E9uysSPhaYiCRI+8SwZS4mWRTdbPoYJxwH6izVeKanZjwn3vPKkgK8Z
         geI83ZC5DRzSmbzhAwXL6bT6GqefvNZA7n8+roeMzen5TOiCNlGeIURB1qip9lXL/seh
         y9YQ==
X-Gm-Message-State: ANhLgQ1rUDxqIA/Qjd7J5DKNGQaqvZ2CtWpS7cJ76U5Q5B7wnhL9j+7d
        drRvwLLZeAsfuEBkisB0XSeCOw==
X-Google-Smtp-Source: ADFU+vtQ8O5Y1PM6F0UmZOUKN26i8zxQIQyhtPW125Zc5hSG53QH0td1j2n+ENa9vfAFfbrA/VESQg==
X-Received: by 2002:a7b:ca58:: with SMTP id m24mr1412582wml.76.1583835287712;
        Tue, 10 Mar 2020 03:14:47 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id o5sm3690487wmb.8.2020.03.10.03.14.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 03:14:47 -0700 (PDT)
Date:   Tue, 10 Mar 2020 11:14:46 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v3 09/10] flow_offload: introduce "disabled" HW
 stats type and allow it in mlxsw
Message-ID: <20200310101446.GC2211@nanopsycho>
References: <20200306132856.6041-1-jiri@resnulli.us>
 <20200306132856.6041-10-jiri@resnulli.us>
 <20200306113116.1d7b0955@kicinski-fedora-PC1C0HJN>
 <20200307065637.GA2210@nanopsycho.orion>
 <20200309122014.22f1ed62@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309122014.22f1ed62@kicinski-fedora-PC1C0HJN>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Mar 09, 2020 at 08:20:14PM CET, kuba@kernel.org wrote:
>On Sat, 7 Mar 2020 07:56:37 +0100 Jiri Pirko wrote:
>> >Would it fit better for the bitfield if disabled internally is 
>> >BIT(last type + 1)?   
>> 
>> I don't see why. Anyway, if needed, this can be always tweaked.
>
>Because it makes it impossible for drivers to pass to
>flow_action_hw_stats_types_check() that they support disabled.

Right, they should not call flow_action_hw_stats_types_check()


>
>I thought disabled means "must have no stats" but I think you may want
>it to mean "no stats needed". Which probably makes more sense, right..

Nope, means "must have no stats"

