Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB1D136ED7
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 14:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgAJN5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 08:57:37 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37591 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727503AbgAJN5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 08:57:36 -0500
Received: by mail-wr1-f67.google.com with SMTP id w15so1917146wru.4
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 05:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=OVC6IuEPGG9HW5E9uWnuhqNWzdHilZimhoeo1FLrWTQ=;
        b=MkzhThnScnuosjGNw4wSO0mdbGboVFtGB9uPslgqfa+djX6WMloFDqB67ndjOLkbZ0
         lRlN8x12rR+SI05UGPCPck1E0yPAZb41lXb2H75uMNrXcen6VgG5SFCzfNQ0RgqENU1L
         rfCh+hwL2xc9Q0YJRt5rgqHt4H+cSGq0R/SvAcokiVFUDesX7mlKIgekyxTnw3lABr+9
         7wBb9sGI3I9eXCm4Qth/1nDbU+f6g4xo0DsjhKWbW1frPepjhE8XvvCVZ/RvwFBzJTZF
         T69EAq5O4tDkfbI1LtPRtSzVDY8lZRGnG8I5HYj6gDDGIB8TBm9XqJcmQz8mAMUHATHO
         PBJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:content-transfer-encoding;
        bh=OVC6IuEPGG9HW5E9uWnuhqNWzdHilZimhoeo1FLrWTQ=;
        b=puVBX4DvMc/4jJGG1yrKXQK7b5Y2xNYBR+AUzrORlQkN3RD8+zvo5bdLvvjBaA1jhg
         a++Yx0tZXWNhJVBNBdpxnt17ldO+XC3SGfw5Qp5a2XBrJW14nW3H2T0bOEf5LSWtAJ7Y
         w7c/cwumkfVTg8VV2wPwqQ6WS7MC55Nx/Dp5wj2OM8VL1ZXPGus95VKHEnH0TYOUfZQJ
         e76y9Wnvt2eVl4KSyIlDUwA8dympwK2A+P9cm87GwwpQ0x8T/viysKcto0UxBNwyKjsL
         wTZBEBaUqnr549Hq5hFnNS4PJLHktSyrImlbqhkK0pWSkgq612YpfdP8INTRTRWJg5RM
         rRWw==
X-Gm-Message-State: APjAAAVJxsmJx3s2zH/21JXIDOZVvhvTBRWnezn0N3e14u4lgtUQvieT
        wprsIPOjNHg7FUVuPn45r2FNIAaXYyy/i3ny5dU=
X-Google-Smtp-Source: APXvYqyNiAdpUEojNbXz6ag/mTziHNvAxBJV9YkW7J0fr4qu8bi6AviyypKBqJzzvwyU2fYCfm+CXNnaPBfn/l6uKcw=
X-Received: by 2002:a05:6000:118d:: with SMTP id g13mr3960972wrx.141.1578664654335;
 Fri, 10 Jan 2020 05:57:34 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a5d:558d:0:0:0:0:0 with HTTP; Fri, 10 Jan 2020 05:57:33
 -0800 (PST)
In-Reply-To: <CA+EvRRFFiGc8nBs7=dEqPyvcPyFcT9qzhsFC68dUG5s1_H0Tgw@mail.gmail.com>
References: <CA+EvRRG0dCNC=ZES5Jm5Jr+2pR4G6GPAeYVzk14eoKiMJpZ0ew@mail.gmail.com>
 <CA+EvRRFBY8swOfo+jn7NYoVreAWbxj4PZudp83TONC+3b4Up6A@mail.gmail.com>
 <CA+EvRREyZTFraZOh+QcvHp0+wAHd_iV7YUoSJPMZ+LcjcFWE1Q@mail.gmail.com> <CA+EvRRFFiGc8nBs7=dEqPyvcPyFcT9qzhsFC68dUG5s1_H0Tgw@mail.gmail.com>
From:   Christy Ruth Walton <idrissdaouda11@gmail.com>
Date:   Fri, 10 Jan 2020 05:57:33 -0800
X-Google-Sender-Auth: UPg-ko7LUJJPkpXVbu6dDvjFPK4
Message-ID: <CA+EvRRFs8=wuPDvfzoOWaBQ1U=5mx7MoUnSnFdYNM9uQVGMbKA@mail.gmail.com>
Subject: Fwd: ::::::::::::::::::::Ruth jjjj Christy
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 I want to open Company & Charity Foundation in your country on your
behalf is it okay?

 I=E2=80=99m Christy Ruth Walton from America.
