Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C9E4AF365
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234553AbiBIN4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:56:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiBIN43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:56:29 -0500
X-Greylist: delayed 874 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Feb 2022 05:56:31 PST
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82EB0C0613CA;
        Wed,  9 Feb 2022 05:56:31 -0800 (PST)
Received: from [73.207.192.158] (port=49618 helo=justpickone.org)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <davidtg+robot@justpickone.org>)
        id 1nHnEH-0007oL-Sg; Wed, 09 Feb 2022 07:41:53 -0600
Date:   Wed, 9 Feb 2022 08:41:39 -0500
From:   David T-G <davidtg+robot@justpickone.org>
To:     linux-raid@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2 1/2] lib/raid6/test/Makefile: Use `$(pound)` instead
 of `\#` for Make 4.3
Message-ID: <20220209134139.GA4455@justpickone.org>
References: <20220208152148.48534-1-pmenzel@molgen.mpg.de>
 <d07a9d41-5a8f-a1f3-59f7-d2a75d6df2e5@youngman.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d07a9d41-5a8f-a1f3-59f7-d2a75d6df2e5@youngman.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - www18.qth.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - justpickone.org
X-Get-Message-Sender-Via: www18.qth.com: authenticated_id: dmail@justpickone.org
X-Authenticated-Sender: www18.qth.com: dmail@justpickone.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul, et al --

...and then Wols Lists said...
% 
% On 08/02/2022 15:21, Paul Menzel wrote:
...
% 
% As commented elsewhere, for the sake of us ENGLISH speakers,
% *PLEASE* make that $(hash). A pound sign is £.

Or, even better, $(octothorpe) since that's merely a symbol rather than a
food product or a result of an algorithm on data.  You might even hope
that we hash this out eventually ...


Have a great day!

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

