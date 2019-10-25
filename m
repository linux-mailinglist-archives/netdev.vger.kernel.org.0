Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA2BEE4A35
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 13:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502015AbfJYLp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 07:45:29 -0400
Received: from sonic307-1.consmr.mail.bf2.yahoo.com ([74.6.134.40]:38111 "EHLO
        sonic307-1.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2501994AbfJYLp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 07:45:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1572003927; bh=IF5V/U/WurT+AiOPTJHR/xJXZxB3Za5bphIXo/fXWgU=; h=Date:From:Reply-To:Subject:From:Subject; b=FUS++uzcqwPISOj+2usBN0tdFXALcjNWwE9P3A3Py5p5rIh5pYSUyNE9H8UdVu5gFsfpGbQx3O/FZ7ibS+Kcwgegnye3ULlZPEB+mS4dGC2vfoRxSrcCZRX6w3X9qOgWJ5T4a9U1mosNJpzIypHSoFfX/GTVBOypl0A1KW3Blj79SVpMXOEP5Fl7hi3NktfZCs2rcKe6tg3miF1h/i8mveWJHaSlDVZ/+eMX/Y/3lCxUh2L31TuFAN9+oz3cf8K7i5jB4XFUpihweo9iMd13JaTl1DE1hE8oSHDkMe80FnLtx+9seg2zSzh99bt3aQmMrBeRNAJvfKWjYFNsXrAmyg==
X-YMail-OSG: _V0yO.IVM1mUdlkmODf2LKaq67n5DTIRZWh42yxVKfeL35M5P4qR95RMM8zV2bH
 NUU3qJaE.tyeH03UScXal631DuezZCVaWMCQErVDe1EpLLDeiJruq_0f._qugRz3pb6QC9_Q0n9u
 bVAcumI2s3u3KLxQ3mOOMA0zEBYKToOCp8CSwUX693DXgaJY70S9PlE0M.3bqthL23VY7_p8.RBl
 I0G3Dd.HsDAjomKUXUY23atJ2v5mX1ztFl1wlrrIvWWXuxexuATLafewTNeEh_mzGY_aNQ2zRY4v
 S2sEAez_XEKShXCJRpeWGATFVpHW_TeYePi1k4kg5_3eHWB8FXwGgCjxK53c7v42vIiZypGb3LL9
 SVuh8KhGuL13WR5qUByXJ.rxCdcBTVRLcmfs8jndh4owmvWjAhdt1DtJtIj2pQ9hN8DPmx6D1.Hk
 WgdR_R4rjrhw.l_7oV4g_ereBmOx9AUF1o7gvRImGtdA_fIYPKb_RH3baw4pRrysNx2LMc3JejtK
 TIFXVEwqCBMhz7Sbw6TtBlek0McJucUWh06NWkNn1g48iomBezF7daicdQiVYuH.38kWhLbLGrbD
 7Xb5qI7rvY3VvliGxMBv1kgerRqXFIeIKh7x0wEjp5HjFfW11flIGAhj.Ohgz0uxiwl.glstXB53
 oVhQgtDi9pUIiPPNhOKFr94ycl8LymCEYw8.M6PaVBaNtcxRER.0PMreZNFxI.MxDZ0fHa1IFi8a
 AxfMLFpvcAdEoSYsBK4RAEcD3B.l4Ncqo1fcsdF0wVyUb__va2yP14iz2pVUB_o6r.swmPatVF9g
 5BjbPCziq5Dv3toGp.0_xaDlGn07ygVfiqv2BkTvw90TpDpYjP_riujIOzrkUKDL6YASfB.MT3nn
 YbUb8xkLjxUc6f8dFEG9v4dhLbGnVlPL3mqPz1BIqw9eraNzWAR3e6jMUE1Rs3oZNOeDw4suf1b5
 ARtoRpg8qcEkLrnNm0IYvMCt_0Ckk43ddSR2chCPWdBXqRcvwKOT5vRlD3GgeOyC.oPa8CVxypqO
 ._.bHPpxR1kmi3f0WZUNsxUbd14LPUxDh5k10Ezkw24tv70oILUwjaLBs3U0EKsT0KT9wZRayUAW
 eTu7JEQX2rZmR5cLAIxC_yTN.s531ZmOFBEJ8z1XyOrUryOX8APGF8bQ8EGVMVOH7zDFPFUt2bvx
 p_j6I6NplBgdsJ83Yngpl621v6DcyXog6Q0Yk9qnMByN6YapUM9cuEe8Q5U6FrEha9OHK7FmAgZ9
 v4kiIjKcQYvPsVAV6PtOvda913L0xiW8EsAiWgo.BJhfzey7swlrPlID6yp3ns7fWCPK1fYAreNl
 u9A--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.bf2.yahoo.com with HTTP; Fri, 25 Oct 2019 11:45:27 +0000
Date:   Fri, 25 Oct 2019 11:45:26 +0000 (UTC)
From:   Christopher Bernard <jenkins.lisa@frontier.com>
Reply-To: chrisben697@gmail.com
Message-ID: <1718113956.528056.1572003926257@mail.yahoo.com>
Subject: hi
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Greetings,

How are you doing Hope you are alright, I sent you message earlier but no response from you, did you read my proposal email message? Please, I await your feedback.

Regards,

Christopher Bernard.
