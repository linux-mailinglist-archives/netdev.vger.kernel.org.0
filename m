Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DACA10718E
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 12:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbfKVLlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 06:41:17 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:43914 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbfKVLlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 06:41:16 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iY7JJ-000256-KW; Fri, 22 Nov 2019 12:41:13 +0100
Message-ID: <fe198371577479c1e00a80e9cae6f577ab39ce8e.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211_hwsim: set the maximum EIRP output power for
 5GHz
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ramon Fontes <ramonreisfontes@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, davem@davemloft.net
Date:   Fri, 22 Nov 2019 12:41:12 +0100
In-Reply-To: <20191108152013.13418-1-ramonreisfontes@gmail.com> (sfid-20191108_162043_178656_27D57739)
References: <20191108152013.13418-1-ramonreisfontes@gmail.com>
         (sfid-20191108_162043_178656_27D57739)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-11-08 at 12:20 -0300, Ramon Fontes wrote:
> ETSI has been set the maximum EIRP output power to 36 dBm (4000 mW)
> Source: https://www.etsi.org/deliver/etsi_en/302500_302599/302502/01.02.01_60/en_302502v010201p.pdf

How is hwsim related to ETSI? What does it matter?

johannes

