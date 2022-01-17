Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B579948FFBF
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 01:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236489AbiAQAdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 19:33:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233846AbiAQAdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 19:33:16 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E62C061574
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 16:33:16 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id e19so19213780plc.10
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 16:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p3pD/Ro3/tJIVdofBjq9qkR2VLxDcmFA3SEXYrPwksg=;
        b=EYtsd546tEj6tfOTOTCYzT/ePcp2feTrJmL+ix8KYI/2WlfdfH2Uu08WcdVYhpUrdg
         0D7/kglG+06qmVwt7ZnqTJ5oRmYaOd1xJoUyUJc1I1VCKo83W4eflQHMZDN/sdS9TuY4
         VTFrPz6JVa9HBNk8tBlKqkFC6EPb2XHvRr6pT8xJVPiyK+DzkWyv4DbhgYteSkrylgPs
         TS12SaXU/ENw6MGda7U+FCNAkItQD8ML1Z2shbQRIf3L584ys/KNHdXI+HNeIEZFFeNy
         yHkbEonzvxTMOhqhnHF00YDp1xSWH4PmvC9GusWm8yQ4+1CNZ6VwV5csmAceaNqwvPqI
         IspA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p3pD/Ro3/tJIVdofBjq9qkR2VLxDcmFA3SEXYrPwksg=;
        b=AI3Ed3WMeVBuKSia83TEcNeMshRa9u8iS1w+AaSpRVUqOBlTpjDejxtCVGPhKnE1eG
         kCnmWyTZ8O+eNI2/dvtw7bh2O1kz/fOQysOB5t+hXJ9llgsLjLmkYLu1ZbkWpgiEFkuA
         Y36zqdNb4rQX8G06hRRtLD7EGCsji95EY6Eh9TZmjXwcjUHTesmyU+5cQyDyzZEkXU7X
         eWEMypVEtcSQu+k3vO83QPJKypZt+K6MtMhVaVGY8R89x910iuQZ0FekPkvg61kzD1qs
         w85nSoXdkdbA1Srz3udyMA9CLp+8G496fgj6TbwmFx8P54avE0Q6EThacixizLe2qC0x
         w6ww==
X-Gm-Message-State: AOAM530/7lWy8yE5zr/wVDAbGTrVxeB5mXeKmkBiUj9wliJC2ZBRRuNE
        NdMQcE63I+oCV93jA3F+Mk5p8UWmlJRW9Q==
X-Google-Smtp-Source: ABdhPJxJS4jfQRxbdve9OEiY60Bkq6CJWGo5HH+l/tjPg+Sfc3giFRqGGpxWOjumESo78eTr5d8EGw==
X-Received: by 2002:a17:90a:2dcd:: with SMTP id q13mr22496405pjm.76.1642379595052;
        Sun, 16 Jan 2022 16:33:15 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id c19sm11774352pfo.91.2022.01.16.16.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 16:33:14 -0800 (PST)
Date:   Sun, 16 Jan 2022 16:33:12 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Re: [PATCH v2 iproute2-next 00/11] clang warning fixes
Message-ID: <20220116163312.460cf1c2@hermes.local>
In-Reply-To: <95299213-6768-e9ed-ea82-1ecb903d86e3@gmail.com>
References: <20220111175438.21901-1-sthemmin@microsoft.com>
        <95299213-6768-e9ed-ea82-1ecb903d86e3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 16 Jan 2022 16:18:53 -0700
David Ahern <dsahern@gmail.com> wrote:

> On 1/11/22 10:54 AM, Stephen Hemminger wrote:
> > This patch set makes iproute2-next main branch compile without warnings
> > on Clang 11 (and probably later versions).
> > 
> > Still needs more testing before merge. There are likely to be some
> > unnecessary output format changes from this.
> >   
> 
> I think the tc patches are the only likely candidates. The
> print_string_name_value conversion should be clean.
> 
> Jamal: As I recall you have a test suite for tc. Can you test this set?

There was a blank after newline and with print_string_name_value that goes away.
Lets introduce something like print_nl_indent() to handle that
