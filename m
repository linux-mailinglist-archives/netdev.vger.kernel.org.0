Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A7F21E31F
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 00:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgGMWl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 18:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbgGMWl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 18:41:27 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A599C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 15:41:27 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id d4so6698113pgk.4
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 15:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pbIi0rPOl77gKZJ9HU5CGROiWIzakPURJKpSHfPsjZU=;
        b=p5wipaCLMO/NUYkykgxUyuVC23Md+i7hh5sCJC/y2vTmD7LOQ8GoMCGCUmA665MsbT
         uvuBZUTgSBTs0cr+OQLQqN9deAIlUDJud+3L+IFUgEG1eqRhsyveKZ+5RQtfJs79TyEN
         XYbNi5A+OjKB+OSdSnOrmcJ3bomVmNTF0DnfpN+gGNxR0M8WZ/CiG6J9kWthwWEZ+I7c
         UyZp+qQKLFeJacXIUJvvfenr8XR/1yClguH4xBBSVaN36zpUePdtxxAMs063f8qAFbg8
         BT4y+0UwVkMRCIIDG8x6tDfndww8zdKblK6bhOvXTFwsjexh/+NxTPvvXaAOsBwALZgZ
         g/5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pbIi0rPOl77gKZJ9HU5CGROiWIzakPURJKpSHfPsjZU=;
        b=jXPggQ+CRvqIXRZ+452ACW6Ctq07T4WTy8geglyjvR1+mmDWmF+a4IHEYTjddnPJIT
         sL7TxDnJIPfDZGckCuSDDkE5rJQ04wnm/Skc+Oa1n0qvsBoyo4to4Bnm6BiMVI0yMyNT
         uPbutp3qmUobfhY4o9DNyYurDFxbUhhUL9Ms0oTJmVjd7whP5h8fn32nNAs4GkrLV3Ti
         iZTF5Vg/RMzp22TdgtjvBtbtSVe8IPr5TE4jp4xxVq25kQU5eN+tNRoqGqxH+8uaTn0p
         alYpTRGiyoIbmxKq9cqx8tk9tf7HQ9hk8aKDaNy+YH10uUNvqk4UYeN8OCK7wMBPiLUL
         G0ag==
X-Gm-Message-State: AOAM530ci9O2JPeYIPtT8FyhkeXdCgv2SS+cp91Aj8wT///FvMFNTvlM
        c9pR7pwkvXeNDJp+mONSjMWgtg==
X-Google-Smtp-Source: ABdhPJxehjrxNk5S2TjjmiWOmanu/MM49tMCczTrbr2GPnrGnbb5kU0NVSlo7qCt6xWb8uxDOeGeYA==
X-Received: by 2002:a62:1801:: with SMTP id 1mr1831676pfy.242.1594680086732;
        Mon, 13 Jul 2020 15:41:26 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id a17sm13419377pgw.60.2020.07.13.15.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 15:41:26 -0700 (PDT)
Date:   Mon, 13 Jul 2020 15:41:18 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Jarod Wilson <jarod@redhat.com>
Subject: Re: [RFC] bonding driver terminology change proposal
Message-ID: <20200713154118.3a1edd66@hermes.lan>
In-Reply-To: <20200713220016.xy4n7c5uu3xs6dyk@lion.mk-sys.cz>
References: <CAKfmpSdcvFG0UTNJFJgXwNRqQb-mk-PsrM5zQ_nXX=RqaaawgQ@mail.gmail.com>
        <20200713220016.xy4n7c5uu3xs6dyk@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jul 2020 00:00:16 +0200
Michal Kubecek <mkubecek@suse.cz> wrote:

> On Mon, Jul 13, 2020 at 02:51:39PM -0400, Jarod Wilson wrote:
> > To start out with, I'd like to attempt to eliminate as much of the use
> > of master and slave in the bonding driver as possible. For the most
> > part, I think this can be done without breaking UAPI, but may require
> > changes to anything accessing bond info via proc or sysfs.  
> 
> Could we, please, avoid breaking existing userspace tools and scripts?
> Massive code churn is one thing and we could certainly bite the bullet
> and live with it (even if I'm still not convinced it would be as great
> idea as some present it) but trading theoretical offense for real and
> palpable harm to existing users is something completely different.
> 
> Or is "don't break userspace" no longer the "first commandment" of linux
> kernel development?
> 
> Michal Kubecek

Please consider using same wording as current standard for link aggregration.
Current version is 802.1AX and it uses the terms:
  Multiplexer /  Aggregator

There are no uses of master or slave in 802.1Ax standard.

As far as userspace, maybe keep the old API's but provide deprecation nags.
And don't document the old API values.
