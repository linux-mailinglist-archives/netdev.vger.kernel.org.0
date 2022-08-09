Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAEE58E15B
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 22:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiHIUxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 16:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiHIUw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 16:52:58 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F13A44B
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 13:52:57 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id d7so12410467pgc.13
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 13:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=bgnJqVc9ZQ9BGAkX0rMeftmXf3pu6Rc3e08JQCfxQHk=;
        b=hYGMgIDlRGZAAbdY3bjI0rLY9qlJWryjAwbBESgtcixNbJKXP7TM5aAu6Pmb6AN08S
         g+/g6c+mB5brgx7WUCowCSkQxYERrWiiCpn1l3Ip2sBVJ2QTxPQwIE5P3smJ5nWWw1P1
         Xsb10Y4mODoMnXHo+OC/pO+E2wneZ54gpsLUD3Bb5C9r0VjQ294zLzaUUyRnIs/HABrw
         rGhoASf4SJ1ektwkVUID66Wh40qxcERmntxP1F2qbYw1Tdq7Wb41ze+8qhNoOM8yWlK/
         P3zhzonYJwBTx4f7CT9fp31QncECh0Vlw4v67Qles3jgTsVj/GqRpiLzf5LDvk0gyz41
         Z3zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=bgnJqVc9ZQ9BGAkX0rMeftmXf3pu6Rc3e08JQCfxQHk=;
        b=HMC3ZFuEXfEmyMt8KP63VXX0UIf0nFOZgDbBXKkxSackzKHY6nmjodZrexsEd3J91u
         0U/V+VfixvFhjgetRl5Qdr+kvJ0lTwaWS+++a5edS9t1RxOPju/MzFiuk/W57xqUw3Sc
         3AFe0H+eIm5sta8DbHhYYqgx6VEUTGdEmvF9aOXoAYeiB9Lg4lhIzMGjzkYGHfYa4ciQ
         SLNCYvQVWKxjIdZvHEgQe5EdGMFmqNlU74L9k6wVGUbYxE5FWrwqVVqch5AyVXrKI7bg
         a2NOGnQNh5MCcju5OSlbYxLb18oc2ypl8O6E7cIJzW7+W7GQwhUkv4ywqQ2E+z9KfyFG
         yxjA==
X-Gm-Message-State: ACgBeo3BkkL1RlEtubggo5eAnitSmfaY9IiGCB1dn8l46dooVjYwy/07
        CXhSqGfSskx6L6sTo0YYXCFovi4ABAY=
X-Google-Smtp-Source: AA6agR4H+xNtcHhuXcryAomYcyn/UrIToOKo8PZ85MYR/Xe50tbYylPy/rdHGMx6SOcP9BMFVZ1/mg==
X-Received: by 2002:a05:6a00:9a7:b0:52d:bbf9:c3d5 with SMTP id u39-20020a056a0009a700b0052dbbf9c3d5mr24629884pfg.9.1660078377031;
        Tue, 09 Aug 2022 13:52:57 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id 18-20020a631752000000b0041d628dde58sm5069520pgx.30.2022.08.09.13.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 13:52:56 -0700 (PDT)
Date:   Tue, 9 Aug 2022 13:52:54 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     =?iso-8859-1?B?Q3Pza+Fz?= Bence <Csokas.Bence@prolan.hu>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] fec: Allow changing the PPS channel
Message-ID: <YvLJJkV2GRJWl7tA@hoboy.vegasvil.org>
References: <20220808131556.163207-1-csokas.bence@prolan.hu>
 <YvEZvCmS9lSoyhDQ@hoboy.vegasvil.org>
 <da7f75cc331744fd8890ffd0f580f220@prolan.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <da7f75cc331744fd8890ffd0f580f220@prolan.hu>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 09, 2022 at 07:36:55AM +0000, Csókás Bence wrote:
> > Don't use a private, custom sysfs knob.  The core PTP layer provides
> > an API for that already.
> 
> Does it? I seem to have missed it. Can you point me at some docs?

See include/uapi/linux/ptp_clock.h:

/*
 * Bits of the ptp_perout_request.flags field:
 */
#define PTP_PEROUT_ONE_SHOT		(1<<0)
#define PTP_PEROUT_DUTY_CYCLE		(1<<1)
#define PTP_PEROUT_PHASE		(1<<2)

/*
 * flag fields valid for the new PTP_PEROUT_REQUEST2 ioctl.
 */
#define PTP_PEROUT_VALID_FLAGS		(PTP_PEROUT_ONE_SHOT | \
					 PTP_PEROUT_DUTY_CYCLE | \
					 PTP_PEROUT_PHASE)

...

struct ptp_perout_request {
	union {
		/*
		 * Absolute start time.
		 * Valid only if (flags & PTP_PEROUT_PHASE) is unset.
		 */
		struct ptp_clock_time start;
		/*
		 * Phase offset. The signal should start toggling at an
		 * unspecified integer multiple of the period, plus this value.
		 * The start time should be "as soon as possible".
		 * Valid only if (flags & PTP_PEROUT_PHASE) is set.
		 */
		struct ptp_clock_time phase;
	};
	struct ptp_clock_time period; /* Desired period, zero means disable. */
	unsigned int index;           /* Which channel to configure. */
	unsigned int flags;
	union {
		/*
		 * The "on" time of the signal.
		 * Must be lower than the period.
		 * Valid only if (flags & PTP_PEROUT_DUTY_CYCLE) is set.
		 */
		struct ptp_clock_time on;
		/* Reserved for future use. */
		unsigned int rsv[4];
	};
};


There is also an API to select pins, with ptp_pin_function,
ptp_pin_desc, PTP_PIN_GETFUNC, PTP_PIN_SETFUNC.

> Also, does it have support for setting pulse mode (i.e. high, low, toggle)?

You can produce a signal with any duty cycle that you wish.  No
support for inverted output, but you could add it if it is important
to you.

Thanks,
Richard
