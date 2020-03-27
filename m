Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBE5195EDF
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 20:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbgC0Tha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 15:37:30 -0400
Received: from mail-qt1-f173.google.com ([209.85.160.173]:37357 "EHLO
        mail-qt1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgC0Tha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 15:37:30 -0400
Received: by mail-qt1-f173.google.com with SMTP id z24so8381190qtu.4;
        Fri, 27 Mar 2020 12:37:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=70nBxb9Uu436nVJwwpRBcaOoIGhWBRxDPAZgJU87ffU=;
        b=UGMykSgv4GjjHpmpN1ZC0aGA9QDNbM+yChrHxlqeb5uWjNGHD1OqURiXgfvax4PuyT
         PWv+8j7/jQmIFl1RpGS2REiMUZTh2cpFWmzX4FyxxzeCZjLA5vqx55XhicFNNVF4JLpm
         su7zB1//GDFB6OkEtRTHbQb98iAl5l+63kDff2bQsncwoZYE3U3psa+e9nSHAGRX9EYl
         BfDTPGQjY5rrUYU9YjFYUDlptEz5Ocle3Fb4lVq2k0dGBqxyf0KjvEvNI9wfhEw25JHo
         YdweWdjiWXR6GnsaWbGgnQ3Q5y2jlCQikspzlIQMhT3i7F7p9yvNGIdH5TAB086FT6Av
         aDyQ==
X-Gm-Message-State: ANhLgQ2ogZWnvyXgoahT8Wklvy1Wp4SJg0zmoqoYJcNdgqSGSecl8LoB
        GL1dO9inj1uv9Gz2swn4tBvsO5UuZRs74DB4y/U=
X-Google-Smtp-Source: ADFU+vtDyK9oxrOasceBXDZUGP854ROLOeSvisvOdyG8f9ZNVDGfJlQ0bQLPdT912y3B5ZsI7v0CS1MY4s++p4b9BiY=
X-Received: by 2002:ac8:4519:: with SMTP id q25mr923260qtn.13.1585337849011;
 Fri, 27 Mar 2020 12:37:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200327042556.11560-1-joe@wand.net.nz> <20200327042556.11560-6-joe@wand.net.nz>
 <CACAyw9-GOw5tkR8n6p7Kct9-wq4B-9ka-X8R2V8uZv8VWUY5UQ@mail.gmail.com>
In-Reply-To: <CACAyw9-GOw5tkR8n6p7Kct9-wq4B-9ka-X8R2V8uZv8VWUY5UQ@mail.gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Fri, 27 Mar 2020 12:37:01 -0700
Message-ID: <CAOftzPh5NKmmFcQ203ie21-nbxtVB9Zon4hO64CXA+xTH8K6nw@mail.gmail.com>
Subject: Re: [PATCHv3 bpf-next 5/5] selftests: bpf: Extend sk_assign tests for UDP
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 3:12 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Fri, 27 Mar 2020 at 04:26, Joe Stringer <joe@wand.net.nz> wrote:
> >
> > Add support for testing UDP sk_assign to the existing tests.
> >
> > Signed-off-by: Joe Stringer <joe@wand.net.nz>
>
> Thanks!
>
> Acked-by: Lorenz Bauer <lmb@cloudflare.com>

Thanks! I assume you meant to ack this on-list but looks like it just
made it to me individually :-)
