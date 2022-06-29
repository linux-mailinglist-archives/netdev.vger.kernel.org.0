Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1BB561E98
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 17:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235624AbiF3PAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 11:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235476AbiF3O7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 10:59:54 -0400
X-Greylist: delayed 23847 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 30 Jun 2022 07:59:42 PDT
Received: from mailgw02.garantiserver.com (mailgw02.dnsflare.com [185.85.205.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FABF1EEC8
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 07:59:42 -0700 (PDT)
Received: from 204139.dnsflare.com ([185.85.204.139]:57922)
        by mailgw02.garantiserver.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <greyson.edwardchevron@gmail.com>)
        id 1o6ZD3-0007w0-0n
        for netdev@vger.kernel.org;
        Wed, 29 Jun 2022 18:02:29 +0300
Received: from 204139.dnsflare.com (localhost [127.0.0.1])
        by 204139.dnsflare.com (Postfix) with ESMTP id 21DC820E60C6
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 18:02:29 +0300 (+03)
X-SASI-Hits: BODYTEXTP_SIZE_3000_LESS 0.000000,
        BODYTEXTP_SIZE_400_LESS 0.000000, BODY_SIZE_1000_LESS 0.000000,
        BODY_SIZE_2000_LESS 0.000000, BODY_SIZE_300_399 0.000000,
        BODY_SIZE_5000_LESS 0.000000, BODY_SIZE_7000_LESS 0.000000,
        CTE_QUOTED_PRINTABLE 0.000000, DKIM_SIGNATURE 0.000000,
        FORGED_FROM_GMAIL 0.100000, FRAUD_X3 1.000000, FROM_NAME_PHRASE 0.000000,
        HTML_00_01 0.050000, HTML_00_10 0.050000, IN_REP_TO 0.000000,
        LEGITIMATE_SIGNS 0.000000, MSG_THREAD 0.000000, MULTIPLE_RCPTS 0.100000,
        NO_CTA_URI_FOUND 0.000000, NO_URI_HTTPS 0.000000, REFERENCES 0.000000,
        REPLYTO_FROM_DIFF_ADDY 0.100000, TO_UNDISCLOSED_RECIPIENTS 0.000000,
        TRANSACTIONAL 0.000000, WEBMAIL_SOURCE 0.000000, WEBMAIL_USER_AGENT 0.000000,
        __ANY_URI 0.000000, __AUTH_RES_DKIM_PASS 0.000000, __BODY_NO_MAILTO 0.000000,
        __BOUNCE_CHALLENGE_SUBJ 0.000000, __BOUNCE_NDR_SUBJ_EXEMPT 0.000000,
        __CT 0.000000, __CTE 0.000000, __CT_TEXT_PLAIN 0.000000,
        __DC_PHRASE 0.000000, __DQ_NEG_DOMAIN 0.000000, __DQ_NEG_HEUR 0.000000,
        __DQ_NEG_IP 0.000000, __FRAUD_INTRO 0.000000, __FRAUD_PARTNERSHIP 0.000000,
        __FRAUD_SUBJ_A 0.000000, __FRAUD_WEBMAIL 0.000000,
        __FRAUD_WEBMAIL_FROM 0.000000, __FROM_DOMAIN_NOT_IN_BODY 0.000000,
        __FROM_GMAIL 0.000000, __FROM_NAME_NOT_IN_BODY 0.000000,
        __FUR_HEADER 0.000000, __HAS_FROM 0.000000, __HAS_MSGID 0.000000,
        __HAS_REFERENCES 0.000000, __HAS_REPLYTO 0.000000, __INT_PROD_LOC 0.000000,
        __IN_REP_TO 0.000000, __MIME_TEXT_ONLY 0.000000, __MIME_TEXT_P 0.000000,
        __MIME_TEXT_P1 0.000000, __MIME_VERSION 0.000000, __MSGID_32HEX 0.000000,
        __NO_HTML_TAG_RAW 0.000000, __PHISH_SPEAR_GREETING 0.000000,
        __PHISH_SPEAR_STRUCTURE_1 0.000000, __PHISH_SPEAR_STRUCTURE_2 0.000000,
        __PHISH_SPEAR_SUBJ_ALERT 0.000000, __REFERENCES 0.000000,
        __SANE_MSGID 0.000000, __SUBJ_ALPHA_NEGATE 0.000000, __SUBJ_REPLY 0.000000,
        __SUBJ_TRANSACTIONAL 0.000000, __SUBJ_TR_GEN 0.000000,
        __TO_MALFORMED_3 0.000000, __URI_MAILTO 0.000000, __URI_NO_WWW 0.000000,
        __URI_NS 0.000000, __USER_AGENT 0.000000,
        __USER_AGENT_ROUNDCUBE_WEBMAIL 0.000000
X-SASI-Probability: 14%
X-SASI-RCODE: 200
X-SASI-Version: Antispam-Engine: 4.1.4, AntispamData: 2022.6.29.143019
Authentication-Results: 204139.dnsflare.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=ornekdomain.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ornekdomain.com;
         h=content-transfer-encoding:user-agent:message-id:references
        :in-reply-to:reply-to:subject:subject:to:from:from:date:date
        :content-type:content-type:mime-version; s=dkim; t=1656514948;
         x=1659106949; bh=lsDT4tvAc3Bj211wDsf28O2PMftqo7mPcbgISGd07Jw=; b=
        lWAE1HQXl2dAqWZStOVEE3EEMOOfqk5d/jOG/aekF6GTm7JgHup5knvM3c0kDY6x
        dvSS8+A4wmQC8upghXwz0mhbsZLDFIV3lDEAG+WcHyD+3or23ZbEC8FUe1z2b5R/
        XXSVgKcDryGOQNDtsuUJnD/D9alyZq8gm0YSCJcEg6c=
X-Virus-Scanned: Debian amavisd-new at dione.dnsflare.com
Received: from 204139.dnsflare.com ([127.0.0.1])
        by 204139.dnsflare.com (204139.dnsflare.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id GvLsfE7b3GG1 for <netdev@vger.kernel.org>;
        Wed, 29 Jun 2022 18:02:28 +0300 (+03)
Received: from _ (localhost [127.0.0.1])
        by 204139.dnsflare.com (Postfix) with ESMTPSA id 2C60520E60E2;
        Wed, 29 Jun 2022 16:38:14 +0300 (+03)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date:   Wed, 29 Jun 2022 14:38:13 +0100
From:   "Chevron HR, Employment" <greyson.edwardchevron@gmail.com>
To:     undisclosed-recipients:;
Subject: Re: Job vacancy notification
Reply-To: greyson@chevron-hr.com
Mail-Reply-To: greyson@chevron-hr.com
In-Reply-To: <b7ba69e8174dfc469ccc7d7ad7a46a5c@gmail.com>
References: <e5091f490ebe479157511bd842971fc0@outlook.com>
 <b7ba69e8174dfc469ccc7d7ad7a46a5c@gmail.com>
Message-ID: <02247ba6bb9fb41073101371308fe6c3@gmail.com>
X-Sender: greyson.edwardchevron@gmail.com
User-Agent: Roundcube Webmail
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=3.6 required=5.0 tests=BAYES_50,DKIM_ADSP_CUSTOM_MED,
        DKIM_INVALID,DKIM_SIGNED,FORGED_GMAIL_RCVD,FREEMAIL_FROM,
        KHOP_HELO_FCRDNS,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ATTN,

      This is to inform you that we are currently hiring foreign=20
international reputable and experienced applicants on various job=20
positions available if you are interested kindly apply by sending your=20
CV/r=C3=A9sum=C3=A9 to greyson@chevron-hr.com for more details.

Regards
Greyson Edwards
EMEA Recruitment Team Lead.
HR Chevron Corporation London UK
