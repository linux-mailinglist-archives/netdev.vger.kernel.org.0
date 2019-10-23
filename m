Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B197DE20C6
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 18:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392529AbfJWQh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 12:37:59 -0400
Received: from mail-qk1-f181.google.com ([209.85.222.181]:45013 "EHLO
        mail-qk1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392525AbfJWQh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 12:37:59 -0400
Received: by mail-qk1-f181.google.com with SMTP id u22so20326728qkk.11
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 09:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=cJMrOdzhAcPuNOXbXu3kf4wHOIGR441jGMjd1HkGJY8=;
        b=Jy+ji8Z+daC+FZ+6LxtuDVJ0Rja/eoNS3h8+nVn0iGNjFEnkEF9b4u8ddc8wtU3BBU
         3On7iGqT53JRa91j3EUM814+zaMZDXcB8eqeuyWMw2cOnZbmY5kO82vDQxNr6r8iBKZ9
         kPXq8AnN9zrNz+sGDNIZgHMC/cVriv0jeo0mBDLRGvo8HJjC7rBFOIDmixa4bCanPdwn
         EZR937oT56dLeMjWgoOOinweXJIxCgAGTY26eIDG9ymKOaLqJS25eJFIqQg167ElMaPj
         aw0S2OSWS+QjVSpMbk6ENFpYgNyc5MJqY+DSO1iNdAhTFHoZs+raL/QcmIlETGs5ef6t
         KXmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=cJMrOdzhAcPuNOXbXu3kf4wHOIGR441jGMjd1HkGJY8=;
        b=ook93qMdIVjLzLqMjZGTx2UdNFndWGJqiQ+MMMuqULrLW9iXBytvAWaUlc5Vt/g3ch
         BE/mO6g3awMRxq8JySIS+ORhWSNpJCmumkStzMcGhSP31SrLv01D21mkMnKGXSdhFWMi
         SDGPbQBZ5nELFyjrotpJpDNz9ea21olA3Uu8UZF0eIVImJXGuerKZH0ivKkI+9qDJ9pr
         4wmSSV2S+wNh+jLWykZWOWRKTil9zLWcxWlW0bcESNiPKc1swRPVfxy2NeHBah2RAIzq
         eguGkPOCPkfZ9n+xKjC2IwL3M17mLRNIOwQHOoavpuhfUmScAzqSfSn6wqjpX5iLgwTK
         1WRQ==
X-Gm-Message-State: APjAAAXrKapEfQuuwR0PQcMhKmkNwfs/nPVp8fYIqMlK7+OKagupF8w8
        m3oVHcx+x/DiIofwaGPytcZu5j1P/Y+BnykRnZL+wKrA+ho=
X-Google-Smtp-Source: APXvYqyKhMrrplNQJ3iIPLYtIA4gLVsonC6AB+vyaRevxRKIA+1JAt3AnnCaOzBZ+pgzAjxlmI82ttqzqqkmNzepBRs=
X-Received: by 2002:a37:4bc2:: with SMTP id y185mr9370196qka.10.1571848677156;
 Wed, 23 Oct 2019 09:37:57 -0700 (PDT)
MIME-Version: 1.0
From:   Levente <leventelist@gmail.com>
Date:   Wed, 23 Oct 2019 18:37:46 +0200
Message-ID: <CACwWb3CYP9MENZJAzBt5buMNxkck7+Qig9yYG8nTYrdBw1fk5A@mail.gmail.com>
Subject: IPv6 test fail
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear list,


We are testing IPv6 again against the test specification of ipv6forum.

https://www.ipv6ready.org/?page=documents&tag=ipv6-core-protocols

The test house state that some certain packages doesn't arrive to the
device under test. We fail test cases

V6LC.1.2.2: No Next Header After Extension Header
V6LC.1.2.3: Unreacognized Next Header in Extension Header - End Node
V6LC.1.2.4: Extension Header Processing Order
V6LC.1.2.5: Option Processing Order
V6LC.1.2.8: Option Processing Destination Options Header

The question is that is it possible that the this is the intended way
of operation? I.e. the kernel swallows those malformed packages? We
use tcpdump to log the traffic.


Thank you for your help.

Levente
