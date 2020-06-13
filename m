Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F001F85A4
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 00:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgFMWaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 18:30:03 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:41427 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgFMWaC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Jun 2020 18:30:02 -0400
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 05DMTdBx019232;
        Sun, 14 Jun 2020 00:29:44 +0200
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 8BA1512093E;
        Sun, 14 Jun 2020 00:29:35 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1592087376; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jMopY+9LrcB7G/NhJIbhU5tWntBoRZ+fpphNAoWOzcI=;
        b=yJezolKenO/Q1v+Q2GPfUFxjGH0OM++0Z/b0DlIQgXPxf92rWmAqt4W6e8Oa21Zu2uP/FF
        qCIk1TZkALynI4BQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1592087376; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jMopY+9LrcB7G/NhJIbhU5tWntBoRZ+fpphNAoWOzcI=;
        b=ffOeHL9/3sykNI1NxyXvsOvUIuDRv/NJ79b1oF4cE4vvxE7uN5SOTRV4DKgaNSnaKBHeuQ
        Y8Sp041Bz9PWeEu4brcXskM8ydX6R8nOf0/M/9bn+TelIbfWAwy0LEqvEl/cib9KP8jKlu
        kVGbfxVlNHPPFM43ZuID5Wh7mDAwEQDzrDFJ9sH4Fesd7fXvAuDycy+9DKqEOBjwMfgC4y
        exfVlnknaPXZzO08TZDWlyoMau+ugcGazrwZSQaZkHdhbla0Zkb9S0ab/PVzG+h8opZd/n
        TkebZ13wocYay2uGSWmihNmbLyqjIJSAA14+blH9MTYgGaiQK4r9qlfTGzIBDg==
Date:   Sun, 14 Jun 2020 00:29:35 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     Dinesh G Dutt <didutt@gmail.com>
Cc:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Donald Sharp <sharpd@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels@gmail.com>
Subject: Re: [RFC,net-next, 0/5] Strict mode for VRF
Message-Id: <20200614002935.3a371a8be63f9424ffdb745c@uniroma2.it>
In-Reply-To: <34a020ef-6024-5253-3e14-be865a7f6de1@gmail.com>
References: <20200612164937.5468-1-andrea.mayer@uniroma2.it>
        <34a020ef-6024-5253-3e14-be865a7f6de1@gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Jun 2020 10:05:49 -0700
Dinesh G Dutt <didutt@gmail.com> wrote:

> Thanks for doing this Andrea. This is a very important patch. I'll let 
> the others comment on the specificity of the patch, but strict mode=1 
> should be the default .
> 
> Dinesh

Hi Dinesh,
thanks for your comments! I chose to disable the strict mode(=0) by default to
be conservative.

Andrea
