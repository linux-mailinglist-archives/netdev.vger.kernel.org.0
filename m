Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07B3DD2FA3
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 19:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbfJJRc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 13:32:57 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:43998 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfJJRc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 13:32:57 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iIcJ3-0001jt-VX; Thu, 10 Oct 2019 19:32:54 +0200
Message-ID: <47343b6d5ccf292bbce8772db5deba674b53a5f8.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211_hwsim: add support for OCB and more 5Ghz
 Channels Signed-off-by: Ramon Fontes <ramonreisfontes@gmail.com>
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ramon Fontes <ramonreisfontes@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, davem@davemloft.net
Date:   Thu, 10 Oct 2019 19:32:53 +0200
In-Reply-To: <20191010173029.8435-1-ramonreisfontes@gmail.com> (sfid-20191010_193114_148958_F3E0A182)
References: <20191010173029.8435-1-ramonreisfontes@gmail.com>
         (sfid-20191010_193114_148958_F3E0A182)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Something went wrong here - your S-o-b landed in the subject?

Also, I think you should really split this into two or three patches
even if it's this simple - theoretically the 5/10 MHz could be
independent of OCB even. To make it perfect, add a few words to each
commit log :)

Thanks,
johannes

