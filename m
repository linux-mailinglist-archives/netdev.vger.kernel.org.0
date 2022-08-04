Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C0258962E
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 04:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234863AbiHDChh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 3 Aug 2022 22:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbiHDChg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 22:37:36 -0400
X-Greylist: delayed 123 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 03 Aug 2022 19:37:35 PDT
Received: from lvs-smtpgate4.nz.fh-koeln.de (lvs-smtpgate4.nz.FH-Koeln.DE [139.6.1.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63785C379
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 19:37:35 -0700 (PDT)
Message-Id: <9fb2d8$1iv728@smtp.intranet.fh-koeln.de>
X-IPAS-Result: =?us-ascii?q?A2D//wDdL+ti/wQiBotaHQEBPAEFBQECAQkBFYFRARoIA?=
 =?us-ascii?q?YEWAgFPAQEBgRSBLAEBK4ROg0+IT4NDAYEpgnWLFYFjBQKPBAsBAQEBAQEBA?=
 =?us-ascii?q?QEJEgIlCQQBAYUDAVMBAQEBB4QdJjgTAQIEAQEBAQMCAwEBAQEBAQMBAQgBA?=
 =?us-ascii?q?QEBBgSBHIUvOQ1fAQEBgQw0AQEBhBABAQEGAQEBK2sgAhkNAkkWRwEBAQGCR?=
 =?us-ascii?q?kUBAQGCHQEBMxOiLIdhgTGBAYIpgSYBgQuCKQWCcoEXKgIBAQGHZ5BcgQ8BA?=
 =?us-ascii?q?oUYHROCUgSXbwICGjgDNBEeNwsDXQgJFxIgAgQRGgsGAxY/CQIEDgNACA0DE?=
 =?us-ascii?q?QQDDxgJEggQBAYDMQwlCwMUDAEGAwYFAwEDGwMUAwUkBwMcDyMNDQQfHQMDB?=
 =?us-ascii?q?SUDAgIbBwICAwIGFQYCAk45CAQIBCsjDwUCBy8FBC8CHgQFBhEIAhYCBgQEB?=
 =?us-ascii?q?AQWAhAIAggnFwcTMxkBBVkQCSEcCR8QBQYTAyBtBUUPKDM1PCsfGwpgJwsqJ?=
 =?us-ascii?q?wQVAwQEAwIGEwMDIgIQLjEDFQYpExItCSp1CQIDIm0DAwQoLgMJPgcJJixMP?=
 =?us-ascii?q?g+WQ4INgTgCMIcLjUKDZQWKVKBbCoNRgUQCk32MKIJGknQOBJF9CYVvhHaME?=
 =?us-ascii?q?KdXgXiBfnCBbgolgRtRGQ+SEopfdAI5AgYBCgEBAwmMZIEKgRgBAQ?=
IronPort-Data: A9a23:8oy6BaMFoaNsAhHvrR3xkcFynXyQoLVcMsEvi/4bfWQNrUojhTUFn
 2UbW2qCb/mINGChe4pya9m+8kIBu5HcmoRlGnM5pCpnJ55oRWspJjg7wmPYZX76whjrFRo/h
 ykmQoCcappyFhcwnz/1WpD5t35wyKqUcbT1De/AK0hZSBRtIMsboUsLd9MR2+aEv/DoW2thh
 vuv+6UzCHf9sxZoP2Qd7b60qR8HlJwebxtB4zTSzdgS1LPvvyF94KA3fMldHFOkKmVgJdNWc
 s6YpF2PEsM1yD92Yj+tuu6TnkTn2dc+NyDW4pZdc/DKbhSvOkXe345jXMfwZ3u7hB2PkNcy7
 o1w7ae6QFkVP47GxvlMdQhXRnQW0a1uoNcrIFCamOfKkmOdNWX0xbNgDAQ1OoAc/KB7DAmi9
 9RBc2FLMFbY26TqqF64YrAEasALKcDgP44ZqHBtiC3EEeoiTLjISuPQ/5lT2zJYasVmQK2CO
 pNJNWoHgBLocgBeOGYqC7UCxciku0jYdx5DsA6MjP9ii4TU5FYoi+G2YIu9lsaxbc9NkG6Gq
 W/cuWf0GBcXMJqY0zXt2ij03LeXwHulANpKT+fgsKQ60QPOgzVWDAAVWB2h5/+0jlWWVNdWK
 khS8S0rxYA29Uq2XpznXgazvjueswcBVsFMO+k78x2WjKvS7RyQCmUNQnhGctNOnNQxQzMu1
 0KDhdr3BDpgmLOfD3ma89+8pDSvESUYJnREbyIeTgYB7silrY0u5jrDR9BiHaqdj9r6FDjqy
 Tea6i4zm907h8wMzaP94VffjjaEqZ3ATwpz7QLSNkqn6QN/IoCsfJCh41Xd4d5PKY+YSh+Ku
 31ss8GF8MgNAIuLmSjLR/8CdJmv6uqJPSP0n1FiBd8i+i6r9nrleppfiBlmLUNsP9wsdTbja
 kLXpUVa45o7FGOjcKsxfIu1Dt8uwLnIDtXrV+7ZKNFJZ/BZdxec/SdhZWab33rqlUkxlOc4I
 5jzWdesFl4UA+Jsyz/eb+4b3aUqxyYWy2mVTpf+pzyk2LSXZVabQ/EON17mRvA4qryNpgr9/
 NNWNs/MwBJaOMX6Yy/K4csJLEsBMz0xAo3woMFMXuqCORZ9XmAnBeXYzb4od8pihas9vr2Qp
 CnlBxcGkAKn3iefb1/aOy4+LemqWYt8oDQheyohOU2A1H0qYILp56AaH7NtJeN/rLE7k6YsF
 6JfI4PaUqURF3GbvjAAbpS7tspkeRCwrQ2LNiuhJjM4evZdqxfh4oe/IlO3qG8QFizyu5Ni5
 bOgkwDcTJ4FAQhvZCrLVB6x51W+ujs7wN8qZEHBfOVSW0+y7dlMOiOk25fbPPowxQX/Kiqyj
 ljLUEtA+LCQ+ufZ4/GU3fDe/tnB//9WQBsKRjKzAaOebHGyw4a1/WNXeMqlFdw3fFz5476vY
 eRTwJkQ29VaxA0a4uKQ/55Nyrgi55PVp75cw0FbEW7Xd1SiDrJpSkRqPPWjVYUUmNe1QSPsB
 iqyFiByYN1k+KrNSTb93jYNYOWZzu0zkTLP9/kzK0iSzHYpoevaDBwOZETd1nc1wF5J3GUNn
 rpJVCk+tFfXt/bWGoza0Ei4CkzTfyxQAvR93n3kKNO601Jyor29XXAsInWvu8jUO4Qk3rgCL
 jKJmLHJh7lHjkTFaWE4FWXL0vFbiIgc0C2mP3ddT2lkW7Pt2JcK4fGm2W9qE1sMkkgWg7ob1
 6oCHxQdGJhiNgxA3KBrN11A0SkQbPFF0iQdE2c0qVA=
IronPort-HdrOrdr: A9a23:Lk7QOaiNEdsPAMy5bLCwW2YViHBQXs0ji2hC6mlwRA09TyRQ//
 rDoB1973LJYVcqM03I9urhBEDtexLhHP1Oi7X5VI3KNDUO3lHYT72LKODZsljd8kbFmdK1u5
 0PT0EEMqyTMWRH
X-IronPort-Anti-Spam-Filtered: true
THK-HEADER: Antispam--identified_spam--outgoing_filter
Received: from p034004.vpn-f04.fh-koeln.de (HELO MAC15F3.vpn.fh-koeln.de) ([139.6.34.4])
  by smtp.intranet.fh-koeln.de with ESMTP/TLS/DHE-RSA-AES128-SHA; 04 Aug 2022 04:34:02 +0200
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Description: Mail message body
Subject: Charity Donation
To:     You <mackenzie-tuttle@ca.rr.com>
From:   "MacKenzie Scott" <mackenzie-tuttle@ca.rr.com>
Date:   Thu, 04 Aug 2022 03:33:59 +0100
Reply-To: mackenzie-tuttle@californiamail.com
X-Priority: 1 (High)
Sensitivity: Company-Confidential
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_50,
        FREEMAIL_FORGED_REPLYTO,MSGID_FROM_MTA_HEADER,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
  My name is MacKenzie Scott Tuttle; I'm a philanthropist and founder of one of the largest private foundations in the world. I'm on a mission to give it all away as I believe in ‘giving while living.’ I always had the idea that never changed in my mind — that wealth should be used to help each other, which has made me decide to donate to you. Kindly acknowledge this message and I will get back to you with more details.

Visit the web page to know more about me: https://www.nytimes.com/2022/04/10/business/mackenzie-scott-charity.html

Regards,
MacKenzie Scott Tuttle.
