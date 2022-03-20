Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFB834E1CED
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 17:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245541AbiCTQuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 12:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbiCTQuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 12:50:12 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F8F34653;
        Sun, 20 Mar 2022 09:48:47 -0700 (PDT)
Received: from [2a04:4540:1401:6400:f8bb:a742:66a1:bedc]
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1nVyjI-00089K-4Z; Sun, 20 Mar 2022 17:48:32 +0100
Message-ID: <af6042d0-952f-f497-57e7-37fef45a1f76@phrozen.org>
Date:   Sun, 20 Mar 2022 17:48:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH] ath9k: initialize arrays at compile time
Content-Language: en-GB
To:     trix@redhat.com, toke@toke.dk, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220320152028.2263518-1-trix@redhat.com>
From:   John Crispin <john@phrozen.org>
In-Reply-To: <20220320152028.2263518-1-trix@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20.03.22 16:20, trix@redhat.com wrote:
> array[size] = { 0 };

should this not be array[size] = { }; ?!

If I recall correctly { 0 } will only set the first element of the 
struct/array to 0 and leave random data in all others elements

	John
