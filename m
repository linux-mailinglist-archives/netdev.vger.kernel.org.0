Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10784147ECB
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 11:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730031AbgAXKeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 05:34:37 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:38080 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgAXKeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 05:34:37 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iuwIK-0011ZT-Cz; Fri, 24 Jan 2020 11:34:32 +0100
Message-ID: <ef348261c1edd9892b09ed017a59be23aa2be688.camel@sipsolutions.net>
Subject: Re: debugging TCP stalls on high-speed wifi
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Date:   Fri, 24 Jan 2020 11:34:31 +0100
In-Reply-To: <CABPxzYJZLHBvtjN7=-hPiUK1XU_b60m8Wpw4tHsT7zOQwZWRVw@mail.gmail.com> (sfid-20191213_101015_988941_7C64060E)
References: <14cedbb9300f887fecc399ebcdb70c153955f876.camel@sipsolutions.net>
         <CADVnQym_CNktZ917q0-9dVY9dhtiJVRRotGTrPNdZUpkjd3vyw@mail.gmail.com>
         <f4670ce0f4399fe82e7168fb9c491d8eb718e8d8.camel@sipsolutions.net>
         <99748db5-7898-534b-d407-ed819f07f939@gmail.com>
         <ff6b35ad589d7cf0710cb9fca4c799538da2e653.camel@sipsolutions.net>
         <CABPxzYJZLHBvtjN7=-hPiUK1XU_b60m8Wpw4tHsT7zOQwZWRVw@mail.gmail.com>
         (sfid-20191213_101015_988941_7C64060E)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-12-13 at 14:40 +0530, Krishna Chaitanya wrote:
> 
> Maybe try 'reno' instead of 'cubic' to see if congestion control is
> being too careful?

I played around with this a bit now, but apart from a few outliers, the
congestion control algorithm doesn't have much effect. The outliers are

 * vegas with ~120 Mbps
 * nv with ~300 Mbps
 * cdg with ~600 Mbps

All the others from my list (reno cubic bbr bic cdg dctcp highspeed htcp
hybla illinois lp nv scalable vegas veno westwood yeah) are within 50
Mbps or so from each other (around 1.45Gbps).

johannes

