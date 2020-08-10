Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5C52403F2
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 11:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgHJJXq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 10 Aug 2020 05:23:46 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:47444 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbgHJJXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 05:23:45 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 3BC9F1C0BD7; Mon, 10 Aug 2020 11:23:42 +0200 (CEST)
Date:   Mon, 10 Aug 2020 11:23:22 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Jonathan Adams <jwadams@google.com>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [RFC PATCH 0/7] metricfs metric file system and examples
Message-ID: <20200810092322.GA12913@localhost>
References: <20200807212916.2883031-1-jwadams@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200807212916.2883031-1-jwadams@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 2020-08-07 14:29:09, Jonathan Adams wrote:
> [resending to widen the CC lists per rdunlap@infradead.org's suggestion
> original posting to lkml here: https://lkml.org/lkml/2020/8/5/1009]
> 
> To try to restart the discussion of kernel statistics started by the
> statsfs patchsets (https://lkml.org/lkml/2020/5/26/332), I wanted
> to share the following set of patches which are Google's 'metricfs'
> implementation and some example uses.  Google has been using metricfs
> internally since 2012 as a way to export various statistics to our
> telemetry systems (similar to OpenTelemetry), and we have over 200
> statistics exported on a typical machine.
> 
> These patches have been cleaned up and modernized v.s. the versions
> in production; I've included notes under the fold in the patches.
> They're based on v5.8-rc6.
> 
> The statistics live under debugfs, in a tree rooted at:
> 
> 	/sys/kernel/debug/metricfs

Is debugfs right place for this? It looks like something where people
would expect compatibility guarantees...

								Pavel

-- 
