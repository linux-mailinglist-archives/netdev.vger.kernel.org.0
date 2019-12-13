Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46BD311DEC9
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 08:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbfLMHna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 02:43:30 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:42382 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbfLMHna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 02:43:30 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iffbj-009Nc2-Ph; Fri, 13 Dec 2019 08:43:27 +0100
Message-ID: <90485ecbfa2a13c4438b840c8a9d37677e833ea5.camel@sipsolutions.net>
Subject: Re: debugging TCP stalls on high-speed wifi
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Justin Capella <justincapella@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Fri, 13 Dec 2019 08:43:26 +0100
In-Reply-To: <CAMrEMU-WdaAe2wOxsnMn=npPyAjf1KkuxA8cHE==yez_rUELUQ@mail.gmail.com> (sfid-20191213_051528_721069_3C6497DE)
References: <14cedbb9300f887fecc399ebcdb70c153955f876.camel@sipsolutions.net>
         <CAMrEMU-WdaAe2wOxsnMn=npPyAjf1KkuxA8cHE==yez_rUELUQ@mail.gmail.com>
         (sfid-20191213_051528_721069_3C6497DE)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-12-12 at 20:15 -0800, Justin Capella wrote:
> Could TCP window size (waiting for ACKnowledgements) be a contributing factor?

Quite possibly, although even with a large number of flows?

I thought we had a TCP_CHRONO_ for it but we don't, maybe I'll try to
add one for debug.

johannes

