Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D390D2A2E81
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 16:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgKBPli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 10:41:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgKBPlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 10:41:37 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B58C0617A6;
        Mon,  2 Nov 2020 07:41:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UmWNoo+0jio1rsbpATbpnTKOP6YpDT2+8aHnhsn1BNQ=; b=cf1MSWB7BC+d/XGfBcQ2kzWTKP
        Peh8sMqwcaL1avawa0skij5vzCJuMhLjyf5+3duC9LV64xK5h7mYlExaCNl16g5xIgy0XYatg9Kkf
        8MzQdAQ7nqnViyK6PC8RcELKGC+j9GZJ7ckJm169iVg6QlV5ggKqdv+lcQqqbrPMl+FlSrL0fJtVH
        h3aIS4VO2YSOq9iZcZt7+s5WtKwHYRjz80MESyljeOHnTABAzm0KwnO67EhkQGqAYQ3ow0H2PyBl3
        OZ6Wcz1eC4cFYhDOYdlGwsV1WdJGKy68/ZW9RvzSJwxRicr1Ax69ZJI0224mH0dP7B11Lada3H09n
        ylAgZRSA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kZbx7-0002Pe-5d; Mon, 02 Nov 2020 15:41:01 +0000
Date:   Mon, 2 Nov 2020 15:41:01 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-gpio@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, alsa-devel@alsa-project.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v2 1/8] mm: slab: provide krealloc_array()
Message-ID: <20201102154101.GO27442@casper.infradead.org>
References: <20201102152037.963-1-brgl@bgdev.pl>
 <20201102152037.963-2-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201102152037.963-2-brgl@bgdev.pl>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 04:20:30PM +0100, Bartosz Golaszewski wrote:
> +Chunks allocated with `kmalloc` can be resized with `krealloc`. Similarly
> +to `kmalloc_array`: a helper for resising arrays is provided in the form of
> +`krealloc_array`.

Is there any reason you chose to `do_this` instead of do_this()?  The
automarkup script turns do_this() into a nice link to the documentation
which you're adding below.

Typo 'resising' resizing.
