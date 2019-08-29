Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89F89A266E
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbfH2Sud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:50:33 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:33590 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727726AbfH2Suc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 14:50:32 -0400
Received: by mail-ed1-f68.google.com with SMTP id l26so4552480edr.0
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 11:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=HwhMWSyxTpqYKImzmjYgPJE/NXztQGBRZykPHgnA0Qk=;
        b=GvZiHHMM6tdlQbCMNnZkL/jeCxhpMJ1gfP6JFbVKPO8QB0+b33lb9YNl8DA6jjt8UB
         q2NJ72UE7AGIMgo1kGkBu2WAEyYrt2bBey4T9TrhuveS+2o+IIzxvqIF1Gl+YNSRGj13
         3RVWp8xtnPwF3vLVMJw4M6hv5T0bJe7ELMY7KVAJBQYYYEY6sb7u7ig0J7JvxILfZYB7
         pVvb3V/FinGChu3yr4Xk//A7jNIpQXJJhBNEP3Bq6wSaHPYbY7vSB5gOyo3dL5dIgSt+
         +sf4GBUNCtD+L/yMcErzRJvI+I4U6gJRNgsKyErfOk9BnGZyNkcyezwzYUOlEp1fAcxI
         1vQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=HwhMWSyxTpqYKImzmjYgPJE/NXztQGBRZykPHgnA0Qk=;
        b=a5j/RQEKuqsMJB2znVkGOYyPKf0OLEAZFPoXlVA7ODeEyU9Y3WBi/+Ov+Uqi3A7HA/
         2XdUjkgI/nr7uWqNHA/64jcwNf86MfCOhC9X7QcwaNwF1ww56xrnNugxIKpw6zsiUtZ5
         7B4eIkmeLSw5Sfnsz9ouuUwS7Qtd7TSMUbSe/DOK0jO6aiuhDs3M8F3CsJmD4G4aYBCY
         yGJ8MCrbuwGRlPV9LiCNLDdFZ3Xml/yVnRF6d/fJy69mCTMTnbx3CHl40W+6lU/GO0D1
         yEtfI/j9rJJEyDzwFKgpi68mMk7wQyhGz7EuMismpFGBIO7kSoJyeu3n7Fg+PYdNoZoY
         xlFg==
X-Gm-Message-State: APjAAAXx0rS9CcE3R9SK0wnzQzLoilA5lWWd5JsQrOCg5vR1aeMvP273
        QSxEkgxVzWFdI4SP1XeV19gDkw==
X-Google-Smtp-Source: APXvYqwNlriWFt2TSRuOAxcj+oP4UrBjefqfeUjrIQ0gTYmgWvNjjzuJzb1E2nicaEmOMdh1baZYHA==
X-Received: by 2002:a17:906:4683:: with SMTP id a3mr9455143ejr.47.1567104630783;
        Thu, 29 Aug 2019 11:50:30 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id i29sm537490edj.61.2019.08.29.11.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 11:50:30 -0700 (PDT)
Date:   Thu, 29 Aug 2019 11:50:04 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julia Kartseva <hex@fb.com>, ast@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, rdna@fb.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: auto-split of commit. Was: [PATCH bpf-next 04/10] tools/bpf:
 add libbpf_prog_type_(from|to)_str helpers
Message-ID: <20190829115004.2701b217@cakuba.netronome.com>
In-Reply-To: <20190829181039.GD28011@kernel.org>
References: <cover.1567024943.git.hex@fb.com>
        <467620c966825173dbd65b37a3f9bd7dd4fb8184.1567024943.git.hex@fb.com>
        <20190828163422.3d167c4b@cakuba.netronome.com>
        <20190828234626.ltfy3qr2nne4uumy@ast-mbp.dhcp.thefacebook.com>
        <20190829065151.GB30423@kroah.com>
        <20190829171655.fww5qxtfusehcpds@ast-mbp.dhcp.thefacebook.com>
        <20190829181039.GD28011@kernel.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Aug 2019 15:10:39 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Aug 29, 2019 at 10:16:56AM -0700, Alexei Starovoitov escreveu:
> > On Thu, Aug 29, 2019 at 08:51:51AM +0200, Greg Kroah-Hartman wrote:  
> > > That being said, from a "are you keeping the correct authorship info",
> > > yes, it sounds like you are doing the correct thing here.  
> 
> > > Look at what I do for stable kernels, I take the original commit and add
> > > it to "another tree" keeping the original author and s-o-b chain intact,
> > > and adding a "this is the original git commit id" type message to the
> > > changelog text so that people can link it back to the original.  
>  
> > I think you're describing 'git cherry-pick -x'.
> > The question was about taking pieces of the original commit. Not the whole commit.
> > Author field obviously stays, but SOB is questionable.
> > If author meant to change X and Y and Z. Silently taking only Z chunk of the diff
> > doesn't quite seem right.
> > If we document that such commit split happens in Documentation/bpf/bpf_devel_QA.rst
> > do you think it will be enough to properly inform developers?  
> 
> Can't we instead establish the rule that for something to be added to
> tools/include/ it should first land in a separate commit in include/,
> ditto for the other things tools/ copies from the kernel sources.

In practice in for BPF work the tools/include/ patch is always part of
the same patch set, since the patch sets usually include libbpf support,
tests that need libbpf etc.
 
> That was the initial intention of tools/include/ and also that is how
> tools/perf/check-headers.h works, warning when something ot out of sync,
> etc.
> 
> I.e. the tools/ maintainers should refuse patches that touch both
> tools/include and tools/.
> 
> wdyt?

It's not only about include/. The series that sparked this query is
moving code from tools/bpf/ to tools/lib/bpf/. And each move is split
into two commits add and delete. That's utterly pointless and a waste
of reviewers' time.

But the question is larger still. As I said vendors maintain
out-of-tree version of their drivers, by necessity, e.g.:

https://github.com/Netronome/nfp-drv-kmods is a #ifdef'd version of 
driver/net/ethernet/netronome/nfp.

If there is a problem of loosing SOB when we only apply a part of a
commit, e.g.

https://github.com/Netronome/nfp-drv-kmods/commit/79941cccea4a7720539e35a72c3ba789e4d4bf8c

which is part of:

ef01adae0e43 ("net: sched: use major priority number as hardware priority")

upstream - then we really need a clear ruling here.
