Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4490212F533
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 09:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbgACIKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 03:10:42 -0500
Received: from mail-wr1-f45.google.com ([209.85.221.45]:42135 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgACIKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 03:10:41 -0500
Received: by mail-wr1-f45.google.com with SMTP id q6so41520661wro.9
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 00:10:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DL+xar8hELNsnJ6V6TESrpzFghV2T3jgNThfwGiRJ2s=;
        b=EeIyEVYd+3AOkeqcEpkfa0RNTkp5vijOVz+b9Ws9Q4Xyoz8Z5SkDwlMPCNrM5kc/Tl
         20bBcdVRTi3HhLlpVGDEKgJvtVgg0SzSI4l8nWI2RU2jBGi4E+iIZuyHic0QcehDSM3p
         q1rkMtDk+qd3g1jMb5/+i/BUuvFwD322MgLFuk5a9/fiM1XX87aDvcMBOVatTBDZmVgw
         3bBoOQGr8V+QC++lOljuhrHHhgrFUHwvIlGAQ31RXVz3u3qI4J5PomxqS9oEm8XBmZ8+
         tzib6zt4sCcJTjFAccTjobKG3hSJj8nWrryHqPwGK5FrdF00CpX7b6k3GtJBmItncD9X
         2jNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DL+xar8hELNsnJ6V6TESrpzFghV2T3jgNThfwGiRJ2s=;
        b=ow9qHZUCndrus3hHhiOigv5FSGTFxi35E834z5XB4TEBmzspd7jRg2KK3aa88bZOUq
         8yc5JYYo9uacga1SrHH2wV5AJyU7SfnePf6wr5cdDmp3EUJpjbtHrbCEkOboMDjNkCdM
         AkoJKbh1VUgEyqIrHIaKQkj3vQe9h5hhY4Q5hNCBqXMJBGh30c6R4lc5wjvgr+GO7Q4U
         c9bUAtQQXi5Yf7xVyR9Ik4haF9Z9TemIxr9/9gFZiKn64swK4LGX0QkrJykHJvogsQYN
         wYpgFlldVoon+/1IDi2pyR8jBOP2Gg9WVb7cru50TPcdW0GGT49zZCAPyNYfcCpXryba
         3MoA==
X-Gm-Message-State: APjAAAUj7oX0Az4COQQWeO0s0OBejGYBce0/avjXBKdY3eyort16zu6D
        tau5chHrkQSAlw2mGu0Kza9mLFoOs4U=
X-Google-Smtp-Source: APXvYqzq5ort6t2Z20ODESdYr9o7Rh/hCLcjtqdksHdJUDzK2X40mJgG/f9uW0MA4bPZ0kyCnsMiqQ==
X-Received: by 2002:a5d:5267:: with SMTP id l7mr92449030wrc.84.1578039040319;
        Fri, 03 Jan 2020 00:10:40 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id k16sm61684789wru.0.2020.01.03.00.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 00:10:40 -0800 (PST)
Date:   Fri, 3 Jan 2020 09:10:39 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH][net-next] net: remove the check argument from
 __skb_gro_checksum_convert
Message-ID: <20200103081039.GE12930@netronome.com>
References: <1578023460-12331-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1578023460-12331-1-git-send-email-lirongqing@baidu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 03, 2020 at 11:51:00AM +0800, Li RongQing wrote:
> The argument is always ignored, so remove it.
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Reviewed-by: Simon Horman <simon.horman@netronome.com>
