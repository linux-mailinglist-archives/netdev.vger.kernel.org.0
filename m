Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F282562DC
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 00:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgH1WPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 18:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgH1WPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 18:15:41 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CDBFC061264
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 15:15:41 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id w3so1968614ilh.5
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 15:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=uLf4mZPcCyk/dyePVOQmf4G9rBCdpWELYZup+iL9LhY=;
        b=cjz9PuoMLAAIiRzDqOT9nuOorjvEKXDn7hEFXXz5oUs+PgkDzYqZaktt8zNhS2DKBX
         hDajk1BOrXlCc7J27BbcnIlShvJISh0jH22E/ABa5ZB3W3IxrgTBIifgP3+LcPTYaPHH
         /SijvCxNS/HOiZUh1kLJag+FausItNt2Qu/XHmc9wzDqsDvfzwJJC+HFuO/XgNnqCYay
         hwwgPZs2tlfKJlffOAlZ1npN+crVATHR71FjrLQjIL6bHR7DLJGWR+tOQ0ciNTxjy4Z3
         06PtGvLNZkjHeON411vOi4/YFOBErKxH7sipcU+TFjZt3FFFSPEz8QnyNUqqNrWRFakL
         5W9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=uLf4mZPcCyk/dyePVOQmf4G9rBCdpWELYZup+iL9LhY=;
        b=JkJlAhv7hhYXJUN64z6NtOVLI/d5JSd+GS76RuDRxvSW7T5ieebGtJRO1BuGgHkuju
         PXKQlhIni9UW5H4fJ97fe34KG5L73Rv3Di0MYKmAryIJvRLTbpcadgxIrIfGw0aG5s8e
         fo5uF0+eqqo/MsgF79u66Y0wb1knEQrV7FrA0Zk43WC0A3QlccZixy+hemu3QG7B7hm9
         Z9EZC0L6wdLiNG1e05dnPNsGFajpqDhRNaZqY4iDGPvSTwpcdjMC2B1GwC0PzXdfaUWG
         WYa0vuR7+S5kxCyB+0eMCKXq03P33mjUkkOAWTBhnHwXNZAtFV5ldHxrd3OUDWKhCdYY
         q3/g==
X-Gm-Message-State: AOAM530zkOYltKoh4AMXI+EHJk6Vce7h057hSMoK+oXHSLBIEvqQFkzU
        1Oc0+VRCfUW7FB8FIDK0sTkA/cc7pYNv6dn/1FAadl7M3Fnacw==
X-Google-Smtp-Source: ABdhPJxy0AGtS8zdR1cNKqZO4P2hTbjV9cAEYHqvqS0WsgP5wjT3yp2K+POYIgFUA8ibzWq5pBiDm9Se0yZ0tXOipHg=
X-Received: by 2002:a05:6e02:13e9:: with SMTP id w9mr783138ilj.211.1598652940428;
 Fri, 28 Aug 2020 15:15:40 -0700 (PDT)
MIME-Version: 1.0
From:   Denis Gubin <denis.gubin@gmail.com>
Date:   Sat, 29 Aug 2020 01:15:05 +0300
Message-ID: <CAE_-sdmpSSNEt5R2B+v1FaSP+SYCk_khW2KieRL_7xVbR=nfHw@mail.gmail.com>
Subject: tc filter add with handle 800::10:800
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, everyone!

How can I add filter rule with full handle option

tc filter replace dev eno5 parent ffff: pref 49100 handle 800:10:800
protocol ip u32 match u8 0 0

I get error:
Error: cls_u32: Handle specified hash table address mismatch

Why I get error?

Am I right to article below?

handle 800:10:888 is this:
800 - number of hash table
10 - number of divisor
888 - number of filter rule

I appreciate for your answers. Thanks!

-- 
Best regards,
Denis Gubin
