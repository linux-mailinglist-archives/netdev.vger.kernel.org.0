Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65B83139F9
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 15:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbfEDNID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 09:08:03 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39004 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbfEDNID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 09:08:03 -0400
Received: by mail-wr1-f68.google.com with SMTP id a9so11235696wrp.6
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 06:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5KbLPtLxFCr4unD6A+EJk9gfUPXXLjbv91PIZYAV0mM=;
        b=p7Y4Hb1EPJ60lOXyOl3X8wZZhlVuKvi8CKqf1qa/Jl/1QX8OTAqna6WbkTBXbFvVzC
         znB0ouCQQAFnMdEmW9FksVR/Zo4B5ZbuL2MVNtAYpQw7fzszRsHY+ntXfOFoN10Yd/bj
         Z56QYO2cTz099Yj0Tq3MyWB/rWXArYCsQwenoDxZpuvFbzegUfXypsXgXxPau+AQmmFL
         12i7JHvooMLdKfsm2oEINasDZQOZjHS0pITq1QIU6KkHQMtn9db/H/CDYMB8aSn7k9Ul
         FByb6teKMNQuY04/W+cloiROhOUR5oIPVXmr6SbylSwHQutYarFLqytgjcS/Hp3Dogwr
         Qe0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5KbLPtLxFCr4unD6A+EJk9gfUPXXLjbv91PIZYAV0mM=;
        b=Mm85bTeHqiMYu/Mknj3ko4V7MpRAa0WoFh7RKtwypSh2vX1rRKGGUgnRLy4HdZGg5z
         Jvn4sYXt7dRyitfwoHKbesBx8ZSCkzWl4nwr0MuvKytcWqCP3Bkzg49yzAlDJrLHY+AV
         ANFSzud25uz3D1CNikVQfqAzjR0xnOg0QWA+C3y4YuZALyf2gDdGCFqQ+33nRouBoRJl
         un6mfPVdvIy6RJf5UduZLMTddwhat91AhyfxCzAz3QhARsLJ/P3o/1o0UPbG6UuKefPc
         il7TYjxyVg2no2nh+PE+suVXl/pEtBetkkW7VFHHGm/w/Hll8xe+0Trv/3mMWME8vlSY
         oj/A==
X-Gm-Message-State: APjAAAVwCjdpbBOFeddcR8KM08/PJEra7/vs4sP5bL0c9ol39OedEx6t
        LJ6rcxSFVRvxFX3Rn/8ILH7dZw==
X-Google-Smtp-Source: APXvYqy0G5lpfDCyM23iBCw4HaSLYMZfx9PnRWckXB1aZ5BaNY4m9LXry98tr164iwwPSdud5kDADA==
X-Received: by 2002:adf:c788:: with SMTP id l8mr4050098wrg.143.1556975281763;
        Sat, 04 May 2019 06:08:01 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id r6sm908447wrt.54.2019.05.04.06.08.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 04 May 2019 06:08:01 -0700 (PDT)
Date:   Sat, 4 May 2019 15:08:00 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@netronome.com, xiyou.wangcong@gmail.com,
        idosch@mellanox.com, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, gerlitz.or@gmail.com,
        simon.horman@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>
Subject: Re: [PATCH net-next 07/13] net/sched: add police action to the
 hardware intermediate representation
Message-ID: <20190504130800.GH9049@nanopsycho.orion>
References: <20190504114628.14755-1-jakub.kicinski@netronome.com>
 <20190504114628.14755-8-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190504114628.14755-8-jakub.kicinski@netronome.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, May 04, 2019 at 01:46:22PM CEST, jakub.kicinski@netronome.com wrote:
>From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
>
>Add police action to the hardware intermediate representation which
>would subsequently allow it to be used by drivers for offload.
>
>Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
>Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
