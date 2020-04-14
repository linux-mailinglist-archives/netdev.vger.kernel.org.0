Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935A81A7928
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 13:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390804AbgDNLMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 07:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728734AbgDNLME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 07:12:04 -0400
X-Greylist: delayed 1999 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Apr 2020 04:12:04 PDT
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C3AC061A0C;
        Tue, 14 Apr 2020 04:12:03 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jOJTr-00Gtcv-U2; Tue, 14 Apr 2020 13:11:52 +0200
Message-ID: <e118e8790a7706253b94a1b181547f4841af64ce.camel@sipsolutions.net>
Subject: Re: WARNING in hwsim_new_radio_nl
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Paolo Abeni <pabeni@redhat.com>,
        syzbot <syzbot+a4aee3f42d7584d76761@syzkaller.appspotmail.com>,
        davem@davemloft.net, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Date:   Tue, 14 Apr 2020 13:11:50 +0200
In-Reply-To: <66c3db9b1978a384246c729034a934cc558b75a6.camel@redhat.com>
References: <000000000000bb471d05a2f246d7@google.com>
         <66c3db9b1978a384246c729034a934cc558b75a6.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-04-14 at 12:42 +0200, Paolo Abeni wrote:
> #syz test git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master
> 
> I don't see why the bisection pointed to the MPTCP commit ?!?

I just sent an explanation for that :)

Good fix too, I already applied another one just now for an earlier, but
really mostly identical, syzbot warning (and yes, tagged it with both).

johannes

