Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAC3D62596
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390907AbfGHQER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:04:17 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41928 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388618AbfGHQER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:04:17 -0400
Received: by mail-io1-f68.google.com with SMTP id j5so17076317ioj.8
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 09:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=iiP9tfmmaTKzDJS1wt7DSWmvbLx0+id24UTIL9u4ZG0=;
        b=0HhWV88/jMTXJI/TnglAc+2udqzUHgLuw78rXKiZM0NAlTDZ1t8VxNt6EXKIzaLF+L
         jA0KJcJrfiridojd56BxXtmhiG9POb+putY0Bw0iZofjgzv7YlsODd2QMIAIASHsT//t
         IJh5ojgQFK+czUNOu2bWCNCRzofJO2ec9sRWEhW2+iwfBkQ+UiqMzSonbdJ4jQYnfDJq
         pc3AJ5yeu5uDM9Yp00OCHLCILSYDM360Kf4WjKF0XLK2fL0b73mQ6ihonVHxSBkNMbG+
         Dk/vlI/2dn3qMYZrjYqEywkQfTkjif8fGxDhe9VS5fV9RJt1MqCXQJ0kAoq/mNWGBNqy
         B/eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=iiP9tfmmaTKzDJS1wt7DSWmvbLx0+id24UTIL9u4ZG0=;
        b=RdMYAXE6fF7Va7zG8wKpqBrLkzRmewr+pveQp5QSx1sRrgb47I5yX69A6vcfoXrWEA
         kAVf2wJpoqrFdrvtISDqUxDxlhz1d4ZbnClXJ5HCDrBtXTs2mra+Jy83RA0LdYFfKg7c
         9w7CWWJw5mZe1xmvgMoYB4Hitgf5MHzb5MZ41IRytlqFgddKdFEuT3MgqXtfZ9wGC+mc
         r42JRejXSWnfI0hoMQmcnI+V6C9C7BE711q4SvHdWap3I0T1+nIE6KJmmjJexgLWX0di
         KZJhAZK+5GicrPbBx22QIdpclKLqSfeEZyvHvt99xxncYxMJ7a3lbD6XH2OD2rChwXHM
         A1OQ==
X-Gm-Message-State: APjAAAUmTf1Iz6iyIq70emTfTjsf2iKTGLahwgxYnJFX25sRy9i036lS
        8Vha8QisSC5UAt7bCoQzX17G3A==
X-Google-Smtp-Source: APXvYqw2axo45PrFD+as9cANYa2HVDRJdrVwOnvvzR5XG11KvJT1AWmZQwe7LpUObubFhLG+R6Nevw==
X-Received: by 2002:a5d:940b:: with SMTP id v11mr3815535ion.69.1562601856858;
        Mon, 08 Jul 2019 09:04:16 -0700 (PDT)
Received: from sevai ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id z26sm19683231ioi.85.2019.07.08.09.04.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 09:04:16 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH iproute2 1/2] tc: added mask parameter in skbedit action
References: <1562195132-9829-1-git-send-email-mrv@mojatatu.com>
        <20190708081501.665e7ddb@hermes.lan>
Date:   Mon, 08 Jul 2019 12:04:15 -0400
In-Reply-To: <20190708081501.665e7ddb@hermes.lan> (Stephen Hemminger's message
        of "Mon, 8 Jul 2019 08:15:01 -0700")
Message-ID: <85muho5x8g.fsf@mojatatu.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen Hemminger <stephen@networkplumber.org> writes:

> On Wed,  3 Jul 2019 19:05:31 -0400
> Roman Mashak <mrv@mojatatu.com> wrote:
>
>> +	if (tb[TCA_SKBEDIT_MASK]) {
>> +		print_uint(PRINT_ANY, "mask", "/0x%x",
>> +			   rta_getattr_u32(tb[TCA_SKBEDIT_MASK]));
>
> Why not print in hex with.
>
> 	print_hex(PRINT_ANY, "mask", "/%#x",
> 			rta_getattr_u32(tb[TCA_SKBEDIT_MASK]));

Sure, I will send v2.
