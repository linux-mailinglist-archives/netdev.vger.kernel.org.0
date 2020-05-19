Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60441D8DB1
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 04:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgESCmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 22:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgESCmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 22:42:45 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE852C061A0C;
        Mon, 18 May 2020 19:42:43 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id f83so12933156qke.13;
        Mon, 18 May 2020 19:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=U6Xm3GnoqR0tpClTO7SpHed1i/YnCxeBR83QTeBjH5w=;
        b=TyN3fwQYnU+Dwo8xe0D/vAHeluXcrypp1uA51YR3B0OfOem8rTzbQIza2kpxxt2IcM
         /yEGR4RH/SsUlrEivGxv8Uxv7cMBwNuNdz56Ng9RbV4DYzMaseThSGinSMfsb85+FTEs
         V/5UP8QXY7yZ/akLatVtOmrKMiEoQzadLVPz431Z46z2/2JxGhluxNCDSzbF56pwMbPB
         D+NlN6HtEsqNVjkZBViW/S+A6WU+TdQIm8z8QDMUMdTNJCamfRuvoIv8BFkWRHpNGR3y
         IaxSfHGqd06Ry/Sdgn+i7jKKQnlLehh2lBLVotED4ZJSB+f8hq5LbcSoMLmBPeYGYPy4
         FCUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U6Xm3GnoqR0tpClTO7SpHed1i/YnCxeBR83QTeBjH5w=;
        b=o+DmQepgMFdaWxRFRj8Et2dEaT76YbbDB0y3TIOEFC2egIkz7qWfg1DL7W7NPOkKvg
         YPI9gif2VAh9YyJag5zqbojMas9Dgq3iM01Zd7GGaH+b/vKkAwCCTfFfnR9VssCErI4/
         s7FggAazTR7b6h4i/G0HKb+qGEVNrY0dIJ5FC9nIK2fVP63TgZhHAW1GEUu/FAKy02/q
         VO9Ie780t4nApu1eOJn/NtbErdToEj6DjOCK1zfShdtwllDEjyQtfE0OJ2CdSf3s5C2O
         wC8zXwGKsrZE4VSfaDi10fY9ezLlZ46lJhES2hiYu/hqCvhHLGPxB22YWYz53I+BBSSV
         QIag==
X-Gm-Message-State: AOAM533XvHOruVRevX76Jk6aXVVxuMlR/3+Yp7CsIJ+a77xitXViCc3l
        cwGGIgqn3thgIHOIZppDi4hGr/obsFo=
X-Google-Smtp-Source: ABdhPJxSSS8W3iLnS90DuVUU/Jz9BPbjPv78lK61LgKurZyrLKvj9B4ytczfzFOWnlrkxwp//7xZ+w==
X-Received: by 2002:a37:634f:: with SMTP id x76mr18977189qkb.194.1589856162718;
        Mon, 18 May 2020 19:42:42 -0700 (PDT)
Received: from [192.168.1.46] (c-73-88-245-53.hsd1.tn.comcast.net. [73.88.245.53])
        by smtp.gmail.com with ESMTPSA id g5sm9385835qkl.114.2020.05.18.19.42.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 May 2020 19:42:42 -0700 (PDT)
Subject: Re: Maintainers / Kernel Summit 2020 planning kick-off
To:     "Theodore Y. Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        inux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, linux-block@vger.kernel.org,
        "ksummit-discuss@lists.linuxfoundation.org" 
        <ksummit-discuss@lists.linuxfoundation.org>
References: <20200515163956.GA2158595@mit.edu>
From:   Frank Rowand <frowand.list@gmail.com>
Message-ID: <ab983c87-b5e5-8060-251d-d57acd35ffe7@gmail.com>
Date:   Mon, 18 May 2020 21:42:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200515163956.GA2158595@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ ksummit-discuss@lists.linuxfoundation.org

On 5/15/20 11:39 AM, Theodore Y. Ts'o wrote:
> [ Feel free to forward this to other Linux kernel mailing lists as
>   appropriate -- Ted ]

Hi Ted,

Can you please add ksummit-discuss@lists.linuxfoundation.org to future
related emails?

Thanks,

Frank

> 
> This year, the Maintainers and Kernel Summit will NOT be held in
> Halifax, August 25 -- 28th, as a result of the COVID-19 pandemic.
> Instead, we will be pursuing a virtual conference format for both the
> Maintainers and Kernel Summit, around the last week of August.
> 
> As in previous years, the Maintainers Summit is invite-only, where the
> primary focus will be process issues around Linux Kernel Development.
> It will be limited to 30 invitees and a handful of sponsored
> attendees.
> 
> The Kernel Summit is organized as a track which is run in parallel
> with the other tracks at the Linux Plumbers Conference (LPC), and is
> open to all registered attendees of LPC.
> 
> Linus will be generating a core list of people to be invited to the
> Maintainers Summit.  The top ten people from that list will receive
> invites, and then program committee will use the rest of Linus's list
> as a starting point of people to be considered.  People who suggest
> topics that should be discussed at the Maintainers Summit will also
> be added to the list for consideration.  To make topic suggestions for
> the Maintainers Summit, please send e-mail to the
> ksummit-discuss@lists.linuxfoundation.org list with a subject prefix
> of [MAINTAINERS SUMMIT].
> 
> The other job of the program committee will be to organize the program
> for the Kernel Summit.  The goal of the Kernel Summit track will be to
> provide a forum to discuss specific technical issues that would be
> easier to resolve in person than over e-mail.  The program committee
> will also consider "information sharing" topics if they are clearly of
> interest to the wider development community (i.e., advanced training
> in topics that would be useful to kernel developers).
> 
> To suggest a topic for the Kernel Summit, please do two things.
> First, please tag your e-mail with [TECH TOPIC].  As before, please
> use a separate e-mail for each topic, and send the topic suggestions
> to the ksummit-discuss list.
> 
> Secondly, please create a topic at the Linux Plumbers Conference
> proposal submission site and target it to the Kernel Summit track.
> For your convenience you can use:
> 
> 	https://bit.ly/lpc20-submit
> 
> Please do both steps.  I'll try to notice if someone forgets one or
> the other, but your chances of making sure your proposal gets the
> necessary attention and consideration are maximized by submitting both
> to the mailing list and the web site.
> 
> People who submit topic suggestions before June 15th and which are
> accepted, will be given free admission to the Linux Plumbers
> Conference.
> 
> We will be reserving roughly half of the Kernel Summit slots for
> last-minute discussions that will be scheduled during the week of
> Plumbers, in an "unconference style".  This allows last-minute ideas
> that come up to be given given slots for discussion.
> 
> If you were not subscribed on to the kernel-discuss mailing list from
> last year (or if you had removed yourself after the kernel summit),
> you can subscribe to the discuss list using mailman:
> 
>    https://lists.linuxfoundation.org/mailman/listinfo/ksummit-discuss
> 
> The program committee this year is composed of the following people:
> 
> Greg Kroah-Hartman
> Jens Axboe
> Jon Corbet
> Ted Ts'o
> Thomas Gleixner
> 

