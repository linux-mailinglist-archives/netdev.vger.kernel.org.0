Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33625219899
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 08:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgGIG0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 02:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgGIG0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 02:26:43 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B624C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 23:26:43 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id q17so412680pls.9
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 23:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XR3JIr+dmP9xk4G0ko0bQHSWenO384A8wynT3VOwTac=;
        b=uMmwVwCDl39pZvAu9WCsNvYNNil4UM/FHNtl0r2t5/1WLkzELKgYhN6gnfkdCdDo8r
         hui5hOFgIQgp2CemoV+dh4cZxbxa+jc8Dc8zDbJffqg6Hda6dER9ucY+UlAHUtqGMoqL
         BkCymn2VPOnitGOLNvYxUc5lz/9XN4VRXZtpkSy5Tabt3m9gY8nChx3sABeAtTsC/En3
         jOICTenjBtZNEjuD7gQsXGVXuR97oHm0tVgg48929rmVyaoaeZrp9QtO0y/trL4oO6BX
         81A1FtoAaps0H6YVuduAw/kOpQrnbDh225E4Siu7K48cBn1wjWfCx0z+R2YXGin1c5JY
         8VLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XR3JIr+dmP9xk4G0ko0bQHSWenO384A8wynT3VOwTac=;
        b=GUDLbqjV01KHTj/bYfLQjlEWXXbxqv0iJwthrZOXtRxsdmKrw97H/JYSS7+KRtXp50
         i6XLFsv0j9i/cVlRz3BYaWHISHeIGXOJoYxH9Qy0PDnoTerO3JbFVxEq4T3HdPbtWvZ9
         C0kdceL4sVyVycrX8GAKBZZQI7igU3a9B7DuBVrDJcRjPTjmYfxJP4/3JhIs9XnPY6S1
         i7rxh1dvmjKuOy9QTuv2Ii8Pibc/K+FBTnbuJIOMVRZhR0k+Dk9Wo5CK+ubuzB9J2uy+
         20D49+tWIPIuuKW+yA1AO/T2T3IB+sOFymxD/Mvahrf8Mhp5jNvvzTUIsI0EdJ1nwYzL
         JjhA==
X-Gm-Message-State: AOAM533t1tVhjtwHlH7A2YrTvs1DUToFAvRsKobqyRLbMcDczuu1iFwE
        TAbeKNw47JmuTOskrGehI4a9NTwFFDFZEw==
X-Google-Smtp-Source: ABdhPJz76J+OhQaP3Ozt9kVi8Pwu53msyesOKR491ZLjbYe4amYN9L6z2lJaOVIWxUWP+DVWna41fA==
X-Received: by 2002:a17:90a:bf02:: with SMTP id c2mr12828410pjs.114.1594276002560;
        Wed, 08 Jul 2020 23:26:42 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id n63sm1442266pfd.209.2020.07.08.23.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 23:26:42 -0700 (PDT)
Date:   Wed, 8 Jul 2020 23:26:34 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Russell Strong <russell@strong.id.au>
Cc:     netdev@vger.kernel.org
Subject: Re: amplifying qdisc
Message-ID: <20200708232634.0fa0ca19@hermes.lan>
In-Reply-To: <20200709161034.71bf8e09@strong.id.au>
References: <20200709161034.71bf8e09@strong.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Jul 2020 16:10:34 +1000
Russell Strong <russell@strong.id.au> wrote:

> Hi,
> 
> I'm attempting to fill a link with background traffic that is sent
> whenever the link is idle.  To do this I've creates a qdisc that will
> repeat the last packet in the queue for a defined number of times
> (possibly infinite in the future). I am able to control the contents of
> the fill traffic by sending the occasional packet through this qdisc.
> 
> This is works as the root qdisc and below a TBF.  When I try it as a
> leaf of HTB unexpected behaviour ensues.  I suspect my approach is
> violating some rules for qdiscs?  Any help/ideas/pointers would be
> appreciated.

Netem can already do things like this. Why not add to that

