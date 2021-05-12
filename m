Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2600037BFAF
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbhELORF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:17:05 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:41050 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231630AbhELOQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 10:16:37 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 14CEEiap031112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 May 2021 10:14:45 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 448C815C39C2; Wed, 12 May 2021 10:14:44 -0400 (EDT)
Date:   Wed, 12 May 2021 10:14:44 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Mali DP Maintainers <malidp@foss.arm.com>,
        alsa-devel@alsa-project.org, coresight@lists.linaro.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-wired-lan@lists.osuosl.org, keyrings@vger.kernel.org,
        kvm@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-hwmon@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-sgx@vger.kernel.org, linux-usb@vger.kernel.org,
        mjpeg-users@lists.sourceforge.net, netdev@vger.kernel.org,
        rcu@vger.kernel.org
Subject: Re: [PATCH v2 00/40] Use ASCII subset instead of UTF-8 alternate
 symbols
Message-ID: <YJvi1L2ss5Tfi+My@mit.edu>
References: <cover.1620823573.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1620823573.git.mchehab+huawei@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 12, 2021 at 02:50:04PM +0200, Mauro Carvalho Chehab wrote:
> v2:
> - removed EM/EN DASH conversion from this patchset;

Are you still thinking about doing the

EN DASH --> "--"
EM DASH --> "---"

conversion?  That's not going to change what the documentation will
look like in the HTML and PDF output forms, and I think it would make
life easier for people are reading and editing the Documentation/*
files in text form.

				- Ted
