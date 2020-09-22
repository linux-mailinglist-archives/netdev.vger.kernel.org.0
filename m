Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C764327480D
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 20:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgIVSWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 14:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgIVSWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 14:22:04 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA0CC061755;
        Tue, 22 Sep 2020 11:22:04 -0700 (PDT)
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 844492C0;
        Tue, 22 Sep 2020 18:22:02 +0000 (UTC)
Date:   Tue, 22 Sep 2020 12:22:00 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Ville =?UTF-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc:     Lyude Paul <lyude@redhat.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        Eric Dumazet <edumazet@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Taehee Yoo <ap420073@gmail.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        dri-devel@lists.freedesktop.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix Kernel-doc warnings introduced on next-20200921
Message-ID: <20200922122200.149d8e96@lwn.net>
In-Reply-To: <20200922175206.GY6112@intel.com>
References: <cover.1600773619.git.mchehab+huawei@kernel.org>
        <a2c0d1ac02fb4bef142196d837323bcde41e9427.camel@redhat.com>
        <20200922175206.GY6112@intel.com>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Sep 2020 20:52:06 +0300
Ville Syrjälä <ville.syrjala@linux.intel.com> wrote:

> Mea culpa. My doc test build was foiled by the sphinx 2 vs. 3
> regression and I was too lazy to start downgrading things.
> Any ETA for getting that fixed btw?

There's a fix of sorts in docs-next (and thus linux-next) now, has been
there for a few weeks.  Really fixing that problem properly requires more
time than anybody seems to have at the moment.

jon
