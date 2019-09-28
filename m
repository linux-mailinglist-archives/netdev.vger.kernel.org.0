Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6575C1208
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 21:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbfI1TmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 15:42:25 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:33980 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbfI1TmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 15:42:25 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iEIbe-0003MA-Lb; Sat, 28 Sep 2019 21:42:14 +0200
Message-ID: <45e9189be8c9d1be45a425af36547155d4007b5b.camel@sipsolutions.net>
Subject: Re: [PATCH net v4 11/12] net: remove unnecessary variables and
 callback
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        jakub.kicinski@netronome.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com, schuffelen@google.com, bjorn@mork.no
Date:   Sat, 28 Sep 2019 21:42:13 +0200
In-Reply-To: <20190928164843.31800-12-ap420073@gmail.com> (sfid-20190928_185043_211407_3551A1BD)
References: <20190928164843.31800-1-ap420073@gmail.com>
         <20190928164843.31800-12-ap420073@gmail.com>
         (sfid-20190928_185043_211407_3551A1BD)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2019-09-28 at 16:48 +0000, Taehee Yoo wrote:
> This patch removes variables and callback these are related to the nested
> device structure.
> devices that can be nested have their own nest_level variable that
> represents the depth of nested devices.
> In the previous patch, new {lower/upper}_level variables are added and
> they replace old private nest_level variable.
> So, this patch removes all 'nest_level' variables.

Ah, well, I see at least this patch also needs the nesting level tracked
in the netdev, at least the "lower_level".

johannes

