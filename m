Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7529811D8D4
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 22:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731188AbfLLVxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 16:53:53 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:53276 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730784AbfLLVxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 16:53:53 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ifWP6-008BTJ-Q3; Thu, 12 Dec 2019 22:53:48 +0100
Message-ID: <2e66d606e5f1c96c9564d4e0289289eba9653461.camel@sipsolutions.net>
Subject: Re: debugging TCP stalls on high-speed wifi
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>
Cc:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Date:   Thu, 12 Dec 2019 22:53:47 +0100
In-Reply-To: <ccab4fec-ea10-000c-53ef-0ffdadbabbd5@gmail.com> (sfid-20191212_225019_821334_39786E03)
References: <14cedbb9300f887fecc399ebcdb70c153955f876.camel@sipsolutions.net>
         <CADVnQym_CNktZ917q0-9dVY9dhtiJVRRotGTrPNdZUpkjd3vyw@mail.gmail.com>
         <f4670ce0f4399fe82e7168fb9c491d8eb718e8d8.camel@sipsolutions.net>
         <99748db5-7898-534b-d407-ed819f07f939@gmail.com>
         <ff6b35ad589d7cf0710cb9fca4c799538da2e653.camel@sipsolutions.net>
         <ccab4fec-ea10-000c-53ef-0ffdadbabbd5@gmail.com>
         (sfid-20191212_225019_821334_39786E03)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-12-12 at 13:50 -0800, Eric Dumazet wrote:

> I presume you could hack TCP to no longer care about bufferbloat and you'll
> probably match Windows 'performance' on a single flow and a lossless network.
> 
> Ie always send ~64KB TSO packets and fill the queues, inflating RTT.
> 
> Then, in presence of losses, you get a problem because the retransmit packets
> can only be sent _after_ the huge queue that has been put on the sender.

Sure, I'll do it as an experiment. Got any suggestions on how to do
that?

I tried to decrease sk_pacing_shift even further with no effect, I've
also tried many more TCP streams with no effect.

I don't even care about a single flow that much, honestly. The default
test is like 10 or 20 flows anyway.

> If only TCP could predict the future ;)

:)

johannes

