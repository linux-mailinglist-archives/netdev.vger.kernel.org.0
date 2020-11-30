Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47AA12C8B67
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 18:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729418AbgK3RjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 12:39:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:44898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726897AbgK3RjO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 12:39:14 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EB02206DF;
        Mon, 30 Nov 2020 17:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606757913;
        bh=HFFjE9XmgSSYVer9/aKugIZ6a6/sln2JoPbC+j0PUD8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J8EVOor3Z/1QL0gF/GLTYCJqXzHEzoF/l+jyxZ9BfaFOAJoHzWvOOisIDGTcn3q/g
         phDt6DHOyqNWDt4rpr4f04fx1qNrd8hOyEG2KO18yGM6hKJdN8u9vLkQ6yhfcStZWc
         umau9hTezF1Hr/jTOaC0vv7PsApzQsyAKP7j1gEw=
Date:   Mon, 30 Nov 2020 12:38:32 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.9 22/33] vhost scsi: add lun parser helper
Message-ID: <20201130173832.GR643756@sasha-vm>
References: <20201125153550.810101-1-sashal@kernel.org>
 <20201125153550.810101-22-sashal@kernel.org>
 <25cd0d64-bffc-9506-c148-11583fed897c@redhat.com>
 <20201125180102.GL643756@sasha-vm>
 <9670064e-793f-561e-b032-75b1ab5c9096@redhat.com>
 <20201129041314.GO643756@sasha-vm>
 <7a4c3d84-8ff7-abd9-7340-3a6d7c65cfa7@redhat.com>
 <20201129210650.GP643756@sasha-vm>
 <e499986d-ade5-23bd-7a04-fa5eb3f15a56@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <e499986d-ade5-23bd-7a04-fa5eb3f15a56@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 09:33:46AM +0100, Paolo Bonzini wrote:
>On 29/11/20 22:06, Sasha Levin wrote:
>>Plus all the testing we have for the stable trees, yes. It goes beyond
>>just compiling at this point.
>>
>>Your very own co-workers (https://cki-project.org/) are pushing hard on
>>this effort around stable kernel testing, and statements like these
>>aren't helping anyone.
>
>I am not aware of any public CI being done _at all_ done on 
>vhost-scsi, by CKI or everyone else.  So autoselection should be done 
>only on subsystems that have very high coverage in CI.

Where can I find a testsuite for virtio/vhost? I see one for KVM, but
where is the one that the maintainers of virtio/vhost run on patches
that come in?

-- 
Thanks,
Sasha
