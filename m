Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 499CBB1A38
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 10:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387653AbfIMIys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 04:54:48 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:35208 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387402AbfIMIys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 04:54:48 -0400
Received: by mail-ot1-f68.google.com with SMTP id t6so15517700otp.2
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 01:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=LnqH6fH4IV3YRYwgYEiWm4ZbnkOeXuBd75uDDT68uGI=;
        b=cqL1YUJA+cihDBoiORK+X8oYXnKSDQahZGASYjtAsDgx3IbogpmJ5s+Je+yx8F7hF8
         8Lshf6dxXzjca0KIx9XrCNvsr5GxKDLFBcKx8ZHXLfz0KgTbJ0+tSruXXm/b6oyQL/1P
         UKpi5mZPu/Il3u8RU2RKmZJqxg+K7CadEgvkca/Fd/FJmilyxrcw2C6Ukh/V/MzXBwmj
         s5Zvn5UDIUF51OThoa3JZnBPJ95bZib3hOd6X0wnacWR2RDqCeBuDHXjhBEmz8EuNYnb
         UBTHSJkL4ZmatD8CwxYGQGGRXgubF2h6tP1d6V0Duh3m5Nq7DBd9O+C0W26pr9/F0iTO
         5xJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=LnqH6fH4IV3YRYwgYEiWm4ZbnkOeXuBd75uDDT68uGI=;
        b=aYr1qxv+z5ptahzhnrTIPoQLWB51xAHMQymSCilEqj3STpKqDHYE+zrjhT46BLC7AR
         S+9L3Y91QYsYgBba7WZxAoMubI3FhoNY5OaJeH0zDGHhk8Rrw1uWKb7/wFXzJiNdDBFQ
         ufKzrXXNRFcbYy9qaVEto0b3TsX1UCZINrX0yeJfCThMOXeUwRQneEKjSBMwwFQfvDPj
         uCcj2xJWAlvmolQe4mjOrO0l4KibTzsejrC3mE2fSxte6Ha8Zo23x6PutayHcAJNr3/h
         wc+oD5n9Hxqqn/aFX3GEh+X5Gba3flUyhDVAEuzhrw8dvAPjI1tbxKKcgdWNOXAtE84i
         zygQ==
X-Gm-Message-State: APjAAAUIhJZouWVgbsb3O93c4vwoUuwJcEEFWo0zp8Zd9sloN90e9aFP
        P28ZQunFVhBXGbkmPOO6VDlFomMmev1CFm2LF9c=
X-Google-Smtp-Source: APXvYqz4IP2tkUlpe6Ll6ReQgkGxu+gDzVb4v6lURkCrs8gxVVK+3EMb6dvNW9fBzC1AWNy5/W8vWRF30QRh5shEfZk=
X-Received: by 2002:a9d:404a:: with SMTP id o10mr39791375oti.94.1568364886390;
 Fri, 13 Sep 2019 01:54:46 -0700 (PDT)
MIME-Version: 1.0
From:   Mark Smith <markzzzsmith@gmail.com>
Date:   Fri, 13 Sep 2019 18:54:20 +1000
Message-ID: <CAO42Z2xH_R1YQBhpyFVziPnHzWwzNV61VqrVT0yMcdEoTd6ZNQ@mail.gmail.com>
Subject: "[RFC PATCH net-next 2/2] Reduce localhost to 127.0.0.0/16"
To:     dave.taht@gmail.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(Not subscribed to the ML)

Hi,

I've noticed this patch. I don't think it should be applied, as it
contradicts RFC 1122, "Requirements for Internet Hosts --
Communication Layers":

"(g)  { 127, <any> }

                 Internal host loopback address.  Addresses of this form
                 MUST NOT appear outside a host."

RFC 1122 is one of the relatively few Internet Standards, specifically
Standard Number 3:

https://www.rfc-editor.org/standards


Regards,
Mark.
