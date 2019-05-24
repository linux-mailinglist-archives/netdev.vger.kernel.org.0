Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB0329060
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 07:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388335AbfEXF2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 01:28:06 -0400
Received: from mail-it1-f199.google.com ([209.85.166.199]:53399 "EHLO
        mail-it1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731674AbfEXF2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 01:28:05 -0400
Received: by mail-it1-f199.google.com with SMTP id m14so7596443itl.3
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 22:28:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to
         :content-transfer-encoding;
        bh=q9cCO7nqhlgXyUNz1cM4/Qf9S/SQ2WkjNSQAnXjcv4s=;
        b=P/k8KewsPf0dj6eYMfiE3VDht/MQI/DmXflG6yGOL2JI/0wKj2CSRlwj0VDW+WuqEn
         gWCJFTXYT38DAzAqbARY32h0LcDD8pAG5njIxntcoCHmui104B+tNte4j5C8EZb9WNLu
         bAQqXiJC17qd4XE5jcXI2+iMcMyAANnYnV4DP4tG88BFTBTv9JdyHUIDfZIPaQQcuBuu
         bPjSu/DYkSDsk7e4ydM8T18tpze0r8U9SXKVlu+rGXKAOM6W57KiSjPI5br8HZ5JxI6q
         FakK2eWR7O7dzsqWgmLP7WgiOmOqCRFx3EUbUSwnA7VeSi87zJ+fKgUvH+VMMW+9tyWL
         e1pg==
X-Gm-Message-State: APjAAAVAUwPWAHzkupNTF8NwbTmKiOSU9x7GoYUK8DWh3xgCU5k2qwf2
        I5XHPHv9xLkRfPejyFUlb7UBs+zJm6W5TwcJFtGtN5RFOFre
X-Google-Smtp-Source: APXvYqwDDOZn9e8caYZRqq7PZLeP8M7Or+hKD8jRpeN8/ApSvkZcSA2QFvEj87ml6/PDfg0cFh0P0TXKwMQFezxY0xt/kXgpZiGt
MIME-Version: 1.0
X-Received: by 2002:a24:ac0a:: with SMTP id s10mr18291167ite.60.1558675685007;
 Thu, 23 May 2019 22:28:05 -0700 (PDT)
Date:   Thu, 23 May 2019 22:28:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008666df05899b7663@google.com>
Subject: bpf build error
From:   syzbot <syzbot+cbe357153903f8d9409a@syzkaller.appspotmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sDQoNCnN5emJvdCBmb3VuZCB0aGUgZm9sbG93aW5nIGNyYXNoIG9uOg0KDQpIRUFEIGNv
bW1pdDogICAgZTZmNmNkMGQgYnBmOiBzb2NrbWFwLCBmaXggdXNlIGFmdGVyIGZyZWUgZnJvbSBz
bGVlcCBpbiBwcy4uDQpnaXQgdHJlZTogICAgICAgYnBmDQpjb25zb2xlIG91dHB1dDogaHR0cHM6
Ly9zeXprYWxsZXIuYXBwc3BvdC5jb20veC9sb2cudHh0P3g9MTZmMTE2ZTRhMDAwMDANCmtlcm5l
bCBjb25maWc6ICBodHRwczovL3N5emthbGxlci5hcHBzcG90LmNvbS94Ly5jb25maWc/eD1mYzA0
NTEzMTQ3Mjk0N2Q3DQpkYXNoYm9hcmQgbGluazogaHR0cHM6Ly9zeXprYWxsZXIuYXBwc3BvdC5j
b20vYnVnP2V4dGlkPWNiZTM1NzE1MzkwM2Y4ZDk0MDlhDQpjb21waWxlcjogICAgICAgZ2NjIChH
Q0MpIDkuMC4wIDIwMTgxMjMxIChleHBlcmltZW50YWwpDQoNClVuZm9ydHVuYXRlbHksIEkgZG9u
J3QgaGF2ZSBhbnkgcmVwcm9kdWNlciBmb3IgdGhpcyBjcmFzaCB5ZXQuDQoNCklNUE9SVEFOVDog
aWYgeW91IGZpeCB0aGUgYnVnLCBwbGVhc2UgYWRkIHRoZSBmb2xsb3dpbmcgdGFnIHRvIHRoZSBj
b21taXQ6DQpSZXBvcnRlZC1ieTogc3l6Ym90K2NiZTM1NzE1MzkwM2Y4ZDk0MDlhQHN5emthbGxl
ci5hcHBzcG90bWFpbC5jb20NCg0KbmV0L2NvcmUvc2tidWZmLmM6MjM0MDo2OiBlcnJvcjog4oCY
c3RydWN0IG1zZ2hkcuKAmSBoYXMgbm8gbWVtYmVyIG5hbWVkIOKAmGZsYWdz4oCZDQoNCi0tLQ0K
VGhpcyBidWcgaXMgZ2VuZXJhdGVkIGJ5IGEgYm90LiBJdCBtYXkgY29udGFpbiBlcnJvcnMuDQpT
ZWUgaHR0cHM6Ly9nb28uZ2wvdHBzbUVKIGZvciBtb3JlIGluZm9ybWF0aW9uIGFib3V0IHN5emJv
dC4NCnN5emJvdCBlbmdpbmVlcnMgY2FuIGJlIHJlYWNoZWQgYXQgc3l6a2FsbGVyQGdvb2dsZWdy
b3Vwcy5jb20uDQoNCnN5emJvdCB3aWxsIGtlZXAgdHJhY2sgb2YgdGhpcyBidWcgcmVwb3J0LiBT
ZWU6DQpodHRwczovL2dvby5nbC90cHNtRUojc3RhdHVzIGZvciBob3cgdG8gY29tbXVuaWNhdGUg
d2l0aCBzeXpib3QuDQo=
