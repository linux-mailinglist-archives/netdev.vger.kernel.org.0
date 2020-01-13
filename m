Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 688D8138F10
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 11:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbgAMKaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 05:30:06 -0500
Received: from sonic315-22.consmr.mail.ne1.yahoo.com ([66.163.190.148]:39862
        "EHLO sonic315-22.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726001AbgAMKaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 05:30:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1578911405; bh=zI0m+DRhZDm01EKX+YHsQU600DuE8AwybL7Vu4lblwE=; h=Date:From:Reply-To:Subject:References:From:Subject; b=pLXQ9gyFFmRNdXkMpMfVKiTxKxSa380Sdw5W2ur9fundh2mS8qlcAsUoaxHvA4lJDjotgz4SuhbdRPxE/P+aQTYSO9Pi6psRCe/PtFAQMwPIF742ik68e9wbsJr2XhAgfwrz4LuAkQtHJQuu8YlK9VNb5puq2rzWq/cTv0SsdHS/scgdzL8Fs0r0qZyCMAqPOl0xmTKRrHU8J4MX6r6s+3gsDL8yhQrOPXeBg4st7GcgvnfQVv7PhXmrZw6l/86PBo5fyyzXcyNpNmD04c0Z+Gj6N6cE+zE4XvGLRDxbzaLTzmZcA7S0xiMAtIV2mcacGJHwdj73Ds/IRr3rOrDybw==
X-YMail-OSG: nL3hUg8VM1mwWtJEEFMOqb0.xFmM.RkJe2y1Slatrux9.iiDZbjzfsTr14.0nRu
 v_EK796aV8LqKmyEEVxD8aU9jRaiVvY9OaIXA18B_LOXVG8v61mUE073HDvjOpTmzwnikK8wyr4A
 3re29_IooJh9k8CICi.u9HXurIr4Bamc5Ana1s7uiYZk3ulS3cE4YTr5dzxp44zhxsuv8keeQ0Fz
 U2CnxNhQcyAMQiDaYAnzYmFCpwhOjlvh4fd9bXK7hPqhxGHbSs.IwKaQhel7Bbz7PanzQsgm2Xqn
 q0wuB7SWn.QxODBfWTFuqd3p1jq3z8MUCVgE6_CdZY4Pd_KNMLlRtGxwQc_2_LQ2n4mNQU18H.fH
 a_mSwDVHWvJXiPzBTKUk1CJIgZVQ6.dyxDeSheAuLMDGXkjNBGMloO9_gt8K66XxCGjQqNTBPDuN
 mcPkwyU5hmmt6c_RlgSlw693s.Wzb8aXAjIO50mMSkf_iQlOwC8v0gKvRW4DJZFp.Ltrh9L34UHp
 sPQnAbe4IDdzGSW1sxw4voFijeJoJYUjgIsd2tiJSfdjpXCLaxNzzf2260nQ_bOTJ9U_0oWSZ.lS
 80XOeuBvyTODYANiJDDqTzgOXVIlv.agmIX0gHwqsGpfrT9Ny1R0xLFzfnEu9GqsxqWCmvC8lRk6
 dNZU4FVInOmkkzSQ1R4E17WznzRcXrWyImYzFjZZJaEbHgPpm7ekX53CzBm_aUsdmhC9..ewsRVt
 B.LYXZNoLQi6j8fmWH5XVviP6uEt8KMdAfMu00msldshiMt6qP9xBExJV5ELc99vZzzuZSRUuycB
 mufZQ7D.EBufIDmnftOSmUUsAA0Hmvxivr.3N6aUIpUNNIZ2LI5w0hkf0JE9wY7aNwCTkiA4KYkU
 IO4eRDhZsIDmHkw45aIygUwKFkTi8adqpcuyreMeTEZI4XyccyQQx671kCKmu9QnGlM02dTIOKXZ
 iS7oe5UBwTS4eM2i.HtbUSQROhdsQGLbD8wnRuOpVU5XrDN8LmUqb7hPgB.2FV.XMh4AIPuKHC9N
 _KB90qGbTmRFeU2996NHqfjHa7Sn6B.7TIeOngeSdt4cq1xyxssyolq9gvRGdTQPRtX4AgIjaaT3
 cmS6Kevz0cu3hMUxs2LeJzp2YVibKWlopTNU9mZVPFhFTv82qa0iKmVV6cXK3K2U8A6wY1dou32v
 5m7rXNtivDA0eV30dQbGrKaHGFqNR311sCeQ0CTIK1traK_BhO0jp97g8xcH36CPdzDSNjp3dCQ3
 eBQpNNKEbiB5mGayaGW_R9b7vqXP5zDW7db3pJNB2q98Xex2N65AjEY3xqhVQb4tM7VUclcfxvaf
 t
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.ne1.yahoo.com with HTTP; Mon, 13 Jan 2020 10:30:05 +0000
Date:   Mon, 13 Jan 2020 10:30:03 +0000 (UTC)
From:   Lisa Williams <wlisa2633@gmail.com>
Reply-To: lisa.wilams@yahoo.com
Message-ID: <2060975502.10630927.1578911403914@mail.yahoo.com>
Subject: Hi Dear
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <2060975502.10630927.1578911403914.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.14873 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:72.0) Gecko/20100101 Firefox/72.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Hi Dear,

 How are you doing hope you are fine and OK?

I was just going through the Internet search when I found your email address, I want to make a new and special friend, so I decided to contact you to see how we can make it work out if we can. Please I wish you will have the desire with me so that we can get to know each other better and see what happens in future.

My name is Lisa Williams, I am an American, but presently I live in the UK, I will be glad to see your reply for us to know each other better to exchange pictures and details about us.

Yours
Lisa
