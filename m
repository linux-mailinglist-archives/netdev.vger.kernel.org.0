Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEE13E986B
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 09:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfJ3Ioh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 04:44:37 -0400
Received: from ms.lwn.net ([45.79.88.28]:48670 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbfJ3Iog (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 04:44:36 -0400
Received: from localhost.localdomain (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id DA9EE2E4;
        Wed, 30 Oct 2019 08:44:34 +0000 (UTC)
Date:   Wed, 30 Oct 2019 02:44:30 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@netronome.com, linux-doc@vger.kernel.org,
        Simon Horman <simon.horman@netronome.com>
Subject: Re: [PATCH net] Documentation: netdev-FAQ: make all questions into
 headings
Message-ID: <20191030024430.719c73be@lwn.net>
In-Reply-To: <20191029171215.6861-1-jakub.kicinski@netronome.com>
References: <20191029171215.6861-1-jakub.kicinski@netronome.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Oct 2019 10:12:15 -0700
Jakub Kicinski <jakub.kicinski@netronome.com> wrote:

> Make sure all questions are headings. Some questions are
> currently on multiple lines, and the continuation lines
> appear as part of the answer when rendered. One question
> was also missing an underline completely.
> 
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>
> ---
>  Documentation/networking/netdev-FAQ.rst | 35 +++++++++----------------
>  1 file changed, 13 insertions(+), 22 deletions(-)

Thanks for working to improve our documentation!

One quick comment...

[...]

> -Q: I see a network patch and I think it should be backported to stable.
> ------------------------------------------------------------------------
> -Q: Should I request it via stable@vger.kernel.org like the references in
> -the kernel's Documentation/process/stable-kernel-rules.rst file say?
> +Q: I see a network patch and I think it should be backported to stable. Should I request it via stable@vger.kernel.org like the references in the kernel's Documentation/process/stable-kernel-rules.rst file say?
> +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

I don't think that making these massive heading lines actually improves the
experience - for readers of either the plain-text or formatted docs.  If
you really want to create headings, the heading here should be "Stable
backports" or some such with the question appearing below.  But do the
questions really need to be headings?

Thanks,

jon
