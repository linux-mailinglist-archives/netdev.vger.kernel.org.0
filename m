Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 213B11984DA
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgC3TuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:50:02 -0400
Received: from mail-ed1-f49.google.com ([209.85.208.49]:34749 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgC3TuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 15:50:02 -0400
Received: by mail-ed1-f49.google.com with SMTP id o1so4047555edv.1
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 12:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=dbNeX14b6bX01VGUEyt0k4bQHAzsM+tUshS+wL0daz4=;
        b=FRFxqVgXl46HdLVnBh0J3p1lzXeohF+dZ/37H9XIRGf274GARsmBZXnWMUjeWyRdmF
         VwB2gAds4CHUJrxdCQCp6s9O+WONSjL2gujBRj44ki05RPQz969MMmFtwPH9EW6ybl+9
         7f5bAH++AexgszrfkP8g5k4YSTi0jF5pC1oLMg07+aaFEKgU9qxIWNtKVVQjIzeDCcjR
         VtTF+KwpMJOJnvSqe4N8SmB0eWXCmlL2yrxL86TzweRR5haXUHBOeekrFsExchfo7dKc
         fhkNguh7vVJvOgaYAhMg1zX4eZJCrt49P/ai9I/S0moo3s+qUP7iTskrwmhZ4LNh/O75
         iWUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=dbNeX14b6bX01VGUEyt0k4bQHAzsM+tUshS+wL0daz4=;
        b=G3M+RSIcJMylgabQXxv6Qnne4NphN71sHA5+5qniretnEg5kIPEwlTW9AkhUVT/iv4
         GleaHoEd6SLppjQlfGI0eBt3havKXGm9Qw2NTHOzbBlswD2O6CDlfLI9Ri4U9vAyw7/M
         2S8DcSEprf9o4FqCS9qqkIDvkjdPLIMBVWWlc+0+U8pyYdXgbNwIG374rVs/cK0L9Gdo
         PauFyVnvHkszmEwEKEgcOrGZd57iNeWx+BA3VjxJ/Nv6mfIWwDTQzL+XpYKkXvQ/nCZr
         wObm1A1AfG4fl16pNTUtftV00Je/ZtBo1NAue+XWc9H672yZrL+Du1W/4XtBkw5Kg+e4
         LInA==
X-Gm-Message-State: ANhLgQ3jXz7Q7QxoPug7Qb52mWfcW4cnIgu40dGaEw//r0WhmALjoVB3
        6gwoeUUYgRKpjRbxVVf7S7Ngb7/ZdgNiG1jSVGsP9bEjpqc=
X-Google-Smtp-Source: ADFU+vuPmJxuFvVzaATH6z2LOJ73EqgQVE09+Knr2XpAssD2CwybCedj9gMz3CQ9mMQ6C/MESux0UVENGfMf0a+ajQA=
X-Received: by 2002:a50:d614:: with SMTP id x20mr13474740edi.186.1585597800176;
 Mon, 30 Mar 2020 12:50:00 -0700 (PDT)
MIME-Version: 1.0
From:   Vaidas BoQsc <vaidas.boqsc@gmail.com>
Date:   Mon, 30 Mar 2020 19:49:24 +0300
Message-ID: <CAB+qc9CWOOTNruMhcAugmjhCne8a-FG9kk8X6ty8-Ss5CpKp5w@mail.gmail.com>
Subject: A robust correct way to display local ip addresses of the device
 Gautieji x
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Are there any ways to output only the local ipv4 (inet) addresses of
the device using ip command?

I tired this way and both UNKNOWN, Down are not filtered away. Is my
usage of syntax incorrect?

 ip --brief address show up
lo               UNKNOWN        127.0.0.1/8 ::1/128
enp7s0           DOWN
wlp8s0           UP             192.168.0.103/24 fe80::22c:79e4:a646:a7b/64

  Even so, if enp7s0 and lo were filtered, I would still want an
output of simply 192.168.0.103 from ip command which can't be provided
without piping into other tools?
