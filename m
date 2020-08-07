Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8253E23F28E
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 20:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgHGSLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 14:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbgHGSLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 14:11:36 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A26C061756
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 11:11:36 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id s189so2813561iod.2
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 11:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7rB7Q98PRkdeExTea/B9Vc+liUVte4cPoF9IAB8FFTs=;
        b=JwRglh7tLDGteu5XIRPqrLaHVZYXaJDPlxGr2Cex8bOUqV9yWWg513h0JnfBTbumMO
         CLLX1oyJkk3dJU8/paxBj+v1Ad6LUtBLp/Mv1kNUURZeWx4TB3FfAeh13YeVKd3z0se9
         x9kODnMYdzmNSGow1p3OnZkR+j7hKVegO7f9HBUSl3kGIFbRg5Tw5e9j/iyizaHlbcnF
         oEwbr766no1wlV9VzzTt7TicdQ31mPukga/mAAv6Bw/d0dD/9SKVa+QyWOJo3ErjaWfK
         K99530S6SiuhrzjuXc0AOfikJz2tjoYZUkhhICqW9HLHbVtGXQ9EXnXX6Ek4G+4eGtoY
         tUqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7rB7Q98PRkdeExTea/B9Vc+liUVte4cPoF9IAB8FFTs=;
        b=OAy2Gys5uIuy58UJsHMSW2qStxCWjYbSOo74UZrHtLLF7+W6HIc98swv2KeFSLIRSY
         e7BknpeLkD1uxO9/6ePkHgdfntqPOfmkrgpRudE0G3a51eMCl74TOLf04o/KKFQgXIRL
         RBW1fU+ptAVhU0cM7s9CCpVSiQiCy25vl5jsAGqWhbVJX8wUQMU0CyTMKPy6zjwbXFj1
         BonokVhcRCb5tO/M9dyEGEchXehy6t/dQAME+YE4KgB6cYNBMJQ9Pp9zVuBSRH1jAcDw
         1bMIM/tjJlgnvEC25Y2AFzG07lI/fz/VOckPB2VHgWkowF5c17AkTp9zkdaN9PsHd1eD
         kP7A==
X-Gm-Message-State: AOAM530Bz9Wg5VsN+f9JUL63OPTTwU7vpf03vVsgsOHxlJNQiaqOpx/l
        sWCnBFM485k9xaoU1WQJ+o8wZoa10NK0Z2lvoIx7HQ==
X-Google-Smtp-Source: ABdhPJyaMhlcedzTfmb5LO1o8L4UqE/1j1Hg3ZY21+3iKWeBCEtqHcQ5Drrbvjzm7mGiON9vNUvEkVoWtxyZxvn6E0Y=
X-Received: by 2002:a02:29ca:: with SMTP id p193mr6253516jap.131.1596823895978;
 Fri, 07 Aug 2020 11:11:35 -0700 (PDT)
MIME-Version: 1.0
References: <bccd2311-79fa-9d88-3c10-067c2438574d@mojatatu.com>
In-Reply-To: <bccd2311-79fa-9d88-3c10-067c2438574d@mojatatu.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 7 Aug 2020 11:11:24 -0700
Message-ID: <CAM_iQpV4WdrhVbZxO27FC8xbyW1wL1fGuxTsUVnkByKiDQ-8OA@mail.gmail.com>
Subject: Re: rcu build on bug
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 7, 2020 at 8:16 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> I am guessing the hash table got too large.
> Smells like hard coded expectation?

Yeah, that is literally how kfree_rcu() works.

>
> How to fix?

I guess you just have to wrap up kfree() and pass it
to call_rcu().

Thanks.
