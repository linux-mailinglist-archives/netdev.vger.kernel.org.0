Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03641AAF3A
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 19:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416428AbgDORMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 13:12:22 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56942 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1416415AbgDORMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 13:12:16 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jOla5-0004e6-JQ; Wed, 15 Apr 2020 11:12:09 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jOla3-0001gx-82; Wed, 15 Apr 2020 11:12:09 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Richard Palethorpe <rpalethorpe@suse.com>,
        Kees Cook <keescook@chromium.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, security@kernel.org, wg@grandegger.com,
        mkl@pengutronix.de, davem@davemloft.net
References: <20200415113445.11881-1-sashal@kernel.org>
        <20200415113445.11881-68-sashal@kernel.org>
Date:   Wed, 15 Apr 2020 12:09:08 -0500
In-Reply-To: <20200415113445.11881-68-sashal@kernel.org> (Sasha Levin's
        message of "Wed, 15 Apr 2020 07:33:43 -0400")
Message-ID: <87h7xkisln.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jOla3-0001gx-82;;;mid=<87h7xkisln.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+wxNH2X5oEIwUT5tCdku1C684p3kocAA0=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=8.0 tests=ALL_TRUSTED,BAYES_40,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,XMSubLong autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        * -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
        *      [score: 0.3063]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Sasha Levin <sashal@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1971 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 9 (0.5%), b_tie_ro: 8 (0.4%), parse: 0.81 (0.0%),
        extract_message_metadata: 25 (1.3%), get_uri_detail_list: 2.2 (0.1%),
        tests_pri_-1000: 46 (2.3%), tests_pri_-950: 1.24 (0.1%),
        tests_pri_-900: 1.02 (0.1%), tests_pri_-90: 78 (4.0%), check_bayes: 76
        (3.8%), b_tokenize: 8 (0.4%), b_tok_get_all: 7 (0.4%), b_comp_prob:
        2.4 (0.1%), b_tok_touch_all: 54 (2.8%), b_finish: 0.86 (0.0%),
        tests_pri_0: 295 (15.0%), check_dkim_signature: 0.49 (0.0%),
        check_dkim_adsp: 2.4 (0.1%), poll_dns_idle: 1497 (76.0%),
        tests_pri_10: 2.1 (0.1%), tests_pri_500: 1509 (76.6%), rewrite_mail:
        0.00 (0.0%)
Subject: Re: [PATCH AUTOSEL 5.6 068/129] slcan: Don't transmit uninitialized stack data in padding
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


How does this differ from Greg's backports of this patches?

Sasha Levin <sashal@kernel.org> writes:

> From: Richard Palethorpe <rpalethorpe@suse.com>
>
> [ Upstream commit b9258a2cece4ec1f020715fe3554bc2e360f6264 ]
>
> struct can_frame contains some padding which is not explicitly zeroed in
> slc_bump. This uninitialized data will then be transmitted if the stack
> initialization hardening feature is not enabled (CONFIG_INIT_STACK_ALL).
>
> This commit just zeroes the whole struct including the padding.
>
> Signed-off-by: Richard Palethorpe <rpalethorpe@suse.com>
> Fixes: a1044e36e457 ("can: add slcan driver for serial/USB-serial CAN adapters")
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Cc: linux-can@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: security@kernel.org
> Cc: wg@grandegger.com
> Cc: mkl@pengutronix.de
> Cc: davem@davemloft.net
> Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/can/slcan.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
> index a3664281a33fc..4dfa459ef5c73 100644
> --- a/drivers/net/can/slcan.c
> +++ b/drivers/net/can/slcan.c
> @@ -148,7 +148,7 @@ static void slc_bump(struct slcan *sl)
>  	u32 tmpid;
>  	char *cmd = sl->rbuff;
>  
> -	cf.can_id = 0;
> +	memset(&cf, 0, sizeof(cf));
>  
>  	switch (*cmd) {
>  	case 'r':
> @@ -187,8 +187,6 @@ static void slc_bump(struct slcan *sl)
>  	else
>  		return;
>  
> -	*(u64 *) (&cf.data) = 0; /* clear payload */
> -
>  	/* RTR frames may have a dlc > 0 but they never have any data bytes */
>  	if (!(cf.can_id & CAN_RTR_FLAG)) {
>  		for (i = 0; i < cf.can_dlc; i++) {
