Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6D65BF817
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 09:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiIUHqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 03:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiIUHqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 03:46:39 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8367475CE0
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 00:46:38 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 39D6821A1B;
        Wed, 21 Sep 2022 07:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1663746397; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9OXfaeMeZD6jpyL701M66yxkSmfRCNZuUveeI5qc/JU=;
        b=ql1S4jo2l5bsqvRswOXrXKKnEXwDkn0koQrCniOp2RdCbdYmr04/NKk0zVAJItr2hrnnEd
        WVa2TMwLuvMNbvkWoEVl0P9q5AAwuUlie3cYxnYHyh0A/5AAZj/JCoiclELT+Vz8IdnTlv
        1QD7Py1QMCav/2pKPr2xVxMojV+wOtw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1663746397;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9OXfaeMeZD6jpyL701M66yxkSmfRCNZuUveeI5qc/JU=;
        b=lGzEtsl37hWv4yUtCeZ5tWw1i+cIbvZkLKYOL/h6kmqeKlGvfMbBMhRZ9JOgLPW6/13Wu1
        CRs8KdiT9IhPmBAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 227B913A00;
        Wed, 21 Sep 2022 07:46:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id rbllB13BKmPUFAAAMHmgww
        (envelope-from <chrubis@suse.cz>); Wed, 21 Sep 2022 07:46:37 +0000
Date:   Wed, 21 Sep 2022 09:48:33 +0200
From:   Cyril Hrubis <chrubis@suse.cz>
To:     kernel test robot <oliver.sang@intel.com>
Cc:     Patrick Rohr <prohr@google.com>, lkp@intel.com,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        lkp@lists.01.org, "David S . Miller" <davem@davemloft.net>,
        ltp@lists.linux.it, Lorenzo Colitti <lorenzo@google.com>
Subject: Re: [LTP] [tun]  a4d8f18ebc: ltp.ioctl03.fail
Message-ID: <YyrB0fSRu7PvNvLi@yuki>
References: <20220916234552.3388360-1-prohr@google.com>
 <202209211425.14116dd2-oliver.sang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202209211425.14116dd2-oliver.sang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!
> tag=ioctl03 stime=1663640405
> cmdline="ioctl03"
> contacts=""
> analysis=exit
> <<<test_output>>>
> tst_test.c:1526: TINFO: Timeout per run is 0h 02m 30s
> ioctl03.c:76: TINFO: Available features are: 0x7533
> ioctl03.c:80: TPASS: TUN 0x1
> ioctl03.c:80: TPASS: TAP 0x2
> ioctl03.c:80: TPASS: NO_PI 0x1000
> ioctl03.c:80: TPASS: ONE_QUEUE 0x2000
> ioctl03.c:80: TPASS: VNET_HDR 0x4000
> ioctl03.c:80: TPASS: MULTI_QUEUE 0x100
> ioctl03.c:80: TPASS: IFF_NAPI 0x10
> ioctl03.c:80: TPASS: IFF_NAPI_FRAGS 0x20
> ioctl03.c:85: TFAIL: (UNKNOWN 0x400)

Obviously the test fails since new flag has been advertised. The test
will have to be updated once/if this commit hits mainline.

-- 
Cyril Hrubis
chrubis@suse.cz
