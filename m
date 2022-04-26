Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53744510632
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 20:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349904AbiDZSFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 14:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349837AbiDZSFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 14:05:15 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8578927CD0
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 11:02:07 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id bx5so9517220pjb.3
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 11:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=pfbNRIWw+oNu2Vg/VSShpowQCEsSP6teUb/bXB2c904=;
        b=FtOu+eZiV26wDmRUOHmEssMWpKF694Z5sYKGk9aVVTaTs2MJHndeamKGjfrmgJm14m
         Ks/FgAgNUJpws+YqJa565dYABnUJ0ch92Ru9eYEUQysogR66SjTVoeLalN/iwhC9zbb5
         omZ0yl/KHpv++4AFr1vKeTbwsaCZEKxc/0dFTjpO+br+2tq6h3ucwHovvLjCKLmOTCtH
         0RPJ5ti061rvosLOgb+BYwAfCma49jixIHBSeHEyf4fCFnhF6ixsO7ZtPibZRNezjVSi
         b7MttvSQm8z+5eu75xak/MVZF70AtPRK6zb9T2B/qMHwHGEwfjHUJ7KKyQ+dwBkCKEgz
         kBHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pfbNRIWw+oNu2Vg/VSShpowQCEsSP6teUb/bXB2c904=;
        b=vZAZQF08SU+hlS6eYEx2l8ZeAtLe6lz4OVuYZnGYDi81TmEYsJgiJj0VYGs/8c1nIV
         UNaU1PsmFNEn0vGiCgWJ/Ea6gB2HApyzNzlWYe55uKyqLyN5O/GYpii9uEl9uQ5bQXc0
         LktlLOOIIJEPak6ABtTl4qEZ62dhLypOV+KxPZMu+jHnIPWRQHEfr8UndDOkGrlvU/mv
         nJrv/8D7Pip1fekv8w54dcyxYihFNBgRSTd3SYq1FzEQXiA7gNkqNz1jvjpDVEmYwFor
         qbRQUM5OELz+adOkllNO1qlH69etKIbPAikpdlSUOEUBdICQPtbTlVkuEg8l0YT93U5Q
         0mwA==
X-Gm-Message-State: AOAM531zcSvp+2fORxL9+PIatUKx0o7ZcyuOh2rVsC4A1r2S5NDexGHE
        hXp1WtsScqf4CLKPp0GCSc8=
X-Google-Smtp-Source: ABdhPJyg+dhmReIwX/2IYgKO6fwcVMRzI7URvH0sCIPc5jJrfRMEMmYy55vBipT4VsRh/Ml4LxLzzQ==
X-Received: by 2002:a17:902:8d8e:b0:159:4f6:c4aa with SMTP id v14-20020a1709028d8e00b0015904f6c4aamr24782780plo.115.1650996126984;
        Tue, 26 Apr 2022 11:02:06 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id fu7-20020a17090ad18700b001d26f134e43sm3716703pjb.51.2022.04.26.11.02.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 11:02:05 -0700 (PDT)
Message-ID: <2823186c-d495-bd9b-87be-5e98a980ca04@gmail.com>
Date:   Tue, 26 Apr 2022 11:02:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v1 1/4] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Content-Language: en-US
To:     Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, kernel-team@fb.com
References: <20220424022356.587949-1-jonathan.lemon@gmail.com>
 <20220424022356.587949-2-jonathan.lemon@gmail.com>
 <20220425013800.GC4472@hoboy.vegasvil.org>
 <20220425235540.vuacu26xb6bzpxob@bsd-mbp.dhcp.thefacebook.com>
 <20220426025349.GB22745@hoboy.vegasvil.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220426025349.GB22745@hoboy.vegasvil.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/25/22 19:53, Richard Cochran wrote:
> On Mon, Apr 25, 2022 at 04:55:40PM -0700, Jonathan Lemon wrote:
> 
>> We could just have a chip-specific version of this function.  The
>> recovered timestamp is passed back in a structure, so the rest of the
>> code would be unchanged.
> 
> Yeah, but it means that I'll have to check each and every bit of every
> register to see what other random changes are there...
> 
>> Jonathan    (no, not volunteering to do this...)
> 
> For now, just get your chip merged, and then the next chip's driver
> will refactor/reuse as needed.

Agreed, if we want to support Gen1 PHYs we can easily do that with 
adding a table of register offsets per family.
-- 
Florian
