Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D98C14EEB0
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 15:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbgAaOoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 09:44:07 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41351 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728827AbgAaOoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 09:44:07 -0500
Received: by mail-pl1-f196.google.com with SMTP id t14so2816563plr.8
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 06:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=qc/Y3vCb7NYYeqiWXiBIM9qnsqNnnpKIRuYLQTvXC+M=;
        b=WfKQLQ1iitxIdsFgTYwLQgS7Fx9hE2TWqt/YNAM6GCy+MIhP8dIrqnbu+lA4zEzwnR
         D37sx70ILe8b3ALjYN3LOgDA4ivEdB0Bryva3vvu24774+4rttq+rWdcOPP3gPqtT/Qn
         Mjy3RTCQxN5DLQOVK2oEHNbG0C7h82LcoCgzbM++CrVrU9W7QE95ayY6hjijHDg6L+dy
         UmNGWdWVSRrqBHBEcVfQOrWIlGSCLpf3g/FQFzFESGKacrc1TJqYDiEluglWcgVFJkCI
         N8MJZH75YQtB5AJq0lzriT7u+ZOqL8oD3mmK4NeVZC0iJxBRL3DUpT8fDF2OUD6dx5XT
         HEIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=qc/Y3vCb7NYYeqiWXiBIM9qnsqNnnpKIRuYLQTvXC+M=;
        b=glg7naDipelVKloiBFYfhMvZ/wCd1gEwkehcDoZp4g16DDfXZOLvFeqqiedrjEVqgH
         I9OVNP1vf71LelpzpQdMi35s6SjlTaYn74/xQTu/o+++D02fIWfFlI+wT09lruxmkebm
         P1UeuBtdSNaMSgCfcUJO4N8VcO6rnp7BaWkkUKo6ba+4W4BX+xAKDTHvi6ZHjbSiVVDS
         YonOQBJ2VX8j7ttqwy46rrDpyPzyMvtwzSW6y9srfKVEeYHYHoqA04vtIVDbwVUWlvvR
         Rh+a8b/4PaefqpElvO6KTfbZUorSYfiD+N1mwuvYMhC9+T+k6sYz5i2fVrdOhS43ngFX
         at6g==
X-Gm-Message-State: APjAAAViMqNJqkfAu6zE/HPtetKKmRrNHKSCSNtimhaBDcFrbcqA50PU
        N5OwxkGrmNhZ2b9JMTGrsjkIH7IRjih/LfJJraE=
X-Google-Smtp-Source: APXvYqyuZluVoc1IcKf7aEsEB83G/vXITVk7HNqF6AvbiESMWdeOpuD4dHgJN+9fJkC3yvssXDEryX6ax2u3tBEfTrU=
X-Received: by 2002:a17:902:a414:: with SMTP id p20mr10904169plq.7.1580481846730;
 Fri, 31 Jan 2020 06:44:06 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:90a:e003:0:0:0:0 with HTTP; Fri, 31 Jan 2020 06:44:06
 -0800 (PST)
Reply-To: aakkaavvii@gmail.com
From:   Abraham Morrison <awochambers004@gmail.com>
Date:   Fri, 31 Jan 2020 06:44:06 -0800
Message-ID: <CAH2diS5iOoADogo+vGuwdDF5Vs4r93ZLhwBEU4N=4mH2recj=A@mail.gmail.com>
Subject: Good day!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

0JTQvtGA0L7Qs9C+0Lkg0LTRgNGD0LMsDQrQryDQkdCw0YDRgNC40YHRgtC10YAg0JDQstGA0LDQ
sNC8INCc0L7RgNGA0LjRgdC+0L0sINCS0Ysg0L/QvtC70YPRh9C40LvQuCDQvNC+0LUg0L/RgNC1
0LTRi9C00YPRidC10LUg0YHQvtC+0LHRidC10L3QuNC1INC00LvRjw0K0LLQsNGBPyDQoyDQvNC1
0L3RjyDQtdGB0YLRjCDQtNC70Y8g0LLQsNGBINCy0LDQttC90LDRjyDQuNC90YTQvtGA0LzQsNGG
0LjRjyDQviDQstCw0YjQtdC8INC90LDRgdC70LXQtNGB0YLQstC10L3QvdC+0LwNCtGE0L7QvdC0
0LUg0LIg0YDQsNC30LzQtdGA0LUgKDIwIDUwMCAwMDAsMDApINC80LjQu9C70LjQvtC90L7QsiDQ
tNC+0LvQu9Cw0YDQvtCyLCDQvtGB0YLQsNCy0LvQtdC90L3QvtC8INCy0LDQvA0K0L/QvtC60L7Q
udC90YvQvCDRgNC+0LTRgdGC0LLQtdC90L3QuNC60L7QvCwg0LzQuNGB0YLQtdGAINCQ0LvQtdC6
0YHQsNC90LTRgC4g0KLQsNC6INGH0YLQviwg0LXRgdC70Lgg0LLRiw0K0LfQsNC40L3RgtC10YDQ
tdGB0L7QstCw0L3Riywg0YHQstGP0LbQuNGC0LXRgdGMINGB0L4g0LzQvdC+0Lkg0LTQu9GPINCx
0L7Qu9C10LUg0L/QvtC00YDQvtCx0L3QvtC5INC40L3RhNC+0YDQvNCw0YbQuNC4Lg0K0KHQv9Cw
0YHQuNCx0L4uDQrQkdCw0YDRgNC40YHRgtC10YAg0JDQstGA0LDQsNC8INCc0L7RgNGA0LjRgdC+
0L0uDQouLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLg0KRGVhciBGcmllbmQsDQpJIGFtIEJhcnJp
c3RlciBBYnJhaGFtIE1vcnJpc29uLCBEaWQgeW91IHJlY2VpdmUgbXkgcHJldmlvdXMgbWVzc2Fn
ZQ0KdG8geW91PyBJIGhhdmUgYW4gaW1wb3J0YW50IGluZm9ybWF0aW9uIGZvciB5b3UgYWJvdXQg
eW91ciBpbmhlcml0YW5jZQ0KZnVuZCB3b3J0aCBvZiAoJDIwLDUwMCwwMDAuMDApIE1pbGxpb24g
d2hpY2ggd2FzIGxlZnQgZm9yIHlvdSBieSB5b3VyDQpsYXRlIHJlbGF0aXZlLCBNci4gQWxleGFu
ZGVyLiBTbyBpZiB5b3UgYXJlIGludGVyZXN0ZWQgZ2V0IGJhY2sgdG8gbWUNCmZvciBtb3JlIGRl
dGFpbHMuDQpUaGFuayB5b3UuDQpCYXJyaXN0ZXIgQWJyYWhhbSBNb3JyaXNvbi4NCg==
